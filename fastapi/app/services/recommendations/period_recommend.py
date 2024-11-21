from app.models import PeriodRecommendResponse
from datetime import datetime, timedelta
import pandas as pd


def calculate_recommendations_for_all_users(data):
    """
    모든 사용자에 대해 주기 추천 데이터를 계산합니다.
    """
    recommendations = []

    # user_id로 데이터 그룹화
    for user_id, user_data in data.groupby('user_id'):
        user_recommendations = calculate_recommendation_for_items(user_id, user_data)
        for recommendation in user_recommendations:
            # 추천 결과에 user_id 추가
            recommendation_dict = recommendation.dict()
            recommendation_dict['user_id'] = user_id
            recommendations.append(recommendation_dict)

            # # 추천에 user_id를 명시적으로 추가
            # recommendations.extend([{'user_id': user_id, **recommendation} for recommendation in user_recommendations])

    # 전체 사용자 추천 데이터를 DataFrame으로 반환
    return pd.DataFrame(recommendations)


def calculate_recommendation_for_items(user_id, user_purchases):
    """
    특정 사용자의 구매 데이터를 기반으로 추천 항목을 계산합니다.
    """
    recommendations = []

    for item_id, item_purchases in user_purchases.groupby('item_id'):
        if len(item_purchases) >= 2:
            item_purchases = item_purchases.sort_values(by='event_time')
            purchase_intervals = []

            for i in range(1, len(item_purchases)):
                purchase_intervals.append(
                    item_purchases['event_time'].iloc[i] - item_purchases['event_time'].iloc[i - 1]
                )

            avg_interval = sum([interval.days for interval in purchase_intervals]) / len(purchase_intervals)
            weighted_recommendation_start = calculate_weighted_recommendation_date(
                purchase_intervals, item_purchases, avg_interval
            )
            item_name = item_purchases['item_name'].iloc[0] if 'item_name' in item_purchases.columns else "상품명 없음"

            purchase_dates = [purchase_date.strftime('%Y-%m-%d %H:%M:%S') for purchase_date in
                              item_purchases['event_time']]

            recommendations.append(PeriodRecommendResponse(
                user_id=user_id,
                item_id=item_id,
                item_name=item_name,
                recommendation_date=weighted_recommendation_start.strftime('%Y-%m-%d %H:%M:%S'),
                purchase_dates=purchase_dates
            ))
    return recommendations


def calculate_weighted_recommendation_date(purchase_intervals, item_purchases, avg_interval):
    """
    구매 간격과 평균 간격을 기반으로 가중치를 적용한 추천 날짜를 계산합니다.
    """
    if avg_interval >= 45:
        recommendation_factor = 0.9
    else:
        recommendation_factor = 0.8

    total_weight = sum([0.5, 0.3, 0.2][:len(purchase_intervals)])
    weighted_days = 0

    for i, interval in enumerate(purchase_intervals):
        weight = [0.5, 0.3, 0.2][i] if i < 3 else 0.1
        weighted_days += interval.days * weight

    weighted_interval = timedelta(days=weighted_days / total_weight)
    recommendation_days = weighted_interval.days * recommendation_factor
    weighted_interval_with_factor = timedelta(days=recommendation_days)

    last_purchase_date = item_purchases['event_time'].iloc[-1]

    return last_purchase_date + weighted_interval_with_factor


#def filter_recommendations_by_user(recommendation_data, user_id):
#     """
#     특정 사용자의 추천 데이터를 필터링합니다.
#     """
#     return recommendation_data[recommendation_data['user_id'] == user_id]

def filter_recommendations_by_date(recommendation_data, target_date):
    """
    target_date보다 이전 날짜의 추천 데이터를 필터링합니다.

    Args:
        recommendation_data (pd.DataFrame): 추천 데이터가 포함된 데이터프레임.
        target_date (datetime): 기준이 되는 날짜.

    Returns:
        pd.DataFrame: target_date 이전의 추천 데이터를 포함하는 데이터프레임.
    """
    if 'recommendation_date' not in recommendation_data.columns:
        raise ValueError("Dataframe is missing the 'recommendation_date' column.")

    # recommendation_date를 datetime 객체로 변환
    recommendation_data['recommendation_date'] = pd.to_datetime(
        recommendation_data['recommendation_date'], errors='coerce'
    )

    # target_date와 datetime 비교
    filtered_data = recommendation_data[
        recommendation_data['recommendation_date'] < target_date
    ]

    # recommendation_date를 문자열로 변환
    filtered_data['recommendation_date'] = filtered_data['recommendation_date'].dt.strftime('%Y-%m-%d %H:%M:%S')

    return filtered_data