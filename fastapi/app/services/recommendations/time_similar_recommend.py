import pandas as pd
from datetime import datetime, timedelta
from app.models import TimeRecommendResponse, TimeSlotsResponse, TimeRecommendHourResponse


# 자주 이용하는 시간대 배열 생성 함수
def get_frequent_time_slots(data, user_column='user_id', event_column='event_time', count_threshold=1, max_slots=3):
    start_date = datetime.now() - timedelta(days=90)
    data[event_column] = pd.to_datetime(data[event_column], errors='coerce')
    data['hour'] = pd.to_datetime(data[event_column], errors='coerce').dt.hour
    data['date'] = pd.to_datetime(data[event_column], errors='coerce').dt.date

    is_order = data['inter'] == 'order'
    is_valid_service = data['service'].isin(['gs25_pickup', 'gs25_dlvy'])
    is_valid_date = data['event_time'] >= start_date

    filtered_data = data[is_order & is_valid_service & is_valid_date].copy()

    # 사용자별 날짜 및 시간대별 구매 집계
    user_hourly_counts = (filtered_data.groupby([user_column, 'hour', 'date'])
                          .size()
                          .reset_index(name='date_count'))

    # 특정 시간대에서의 이용 횟수가 기준 이상인 데이터 필터링
    user_time_slots = (user_hourly_counts.groupby([user_column, 'hour'])
                       .size()  # 각 사용자와 시간별로 날짜 개수 합산
                       .reset_index(name='order_count'))

    user_time_slots = user_time_slots[user_time_slots['order_count'] >= count_threshold]

    user_time_slots = (user_time_slots.sort_values(by=['order_count'], ascending=False)
                       .groupby(user_column)
                       .head(max_slots))

    # 시간대 배열 생성
    user_time_slots = user_time_slots.groupby(user_column)['hour'].apply(list).reset_index()
    user_time_slots.columns = [user_column, 'frequent_time_slots']

    return user_time_slots


def get_user_recommendations(data, user_id):
    # 자주 사용하는 시간대 배열 생성
    """
    :param: count_threshold = 같은 시간대에 최소 방문하는 횟수
    :param: max_slots = 자주 구매하는 시간대 배열의 최대 길이
    """
    user_time_slots = get_frequent_time_slots(data, count_threshold=3, max_slots=3)

    print(user_time_slots)

    # 사용자의 시간대 정보 가져오기
    user_row = user_time_slots[user_time_slots['user_id'] == user_id]

    if user_row.empty:
        return []

    # 해당 사용자의 시간대 배열
    time_slots = user_row['frequent_time_slots'].values[0]

    # 90일 전부터의 데이터 필터링
    start_date = datetime.now() - timedelta(days=90)
    data['event_time'] = pd.to_datetime(data['event_time'], errors='coerce')

    recommendations = []

    # 각 시간대에 대해 반복
    for time_slot in time_slots:
        # 현재 시간대에 맞는 데이터 필터링
        filtered_data = data[(data['user_id'] == user_id) &
                             (data['inter'] == 'order') &
                             (data['event_time'] >= start_date) &
                             (data['event_time'].dt.hour == time_slot)]  # 특정 시간대 필터링

        # 아이템별 구매 횟수 집계
        item_counts = (filtered_data.groupby(['item_id', 'item_name'])
                       .size()
                       .reset_index(name='purchase_count')
                       .sort_values(by='purchase_count', ascending=False))

        # 현재 시간대의 추천 리스트 생성
        time_recommendations = [
            TimeRecommendResponse(
                user_id=user_id,
                time_pattern=time_slot,
                item_id=row['item_id'],
                item_name=row['item_name'],
                purchase_count=row['purchase_count']
            )
            for _, row in item_counts.iterrows()
        ]

        # 시간대별 결과 추가
        recommendations.extend(time_recommendations)

    return recommendations


def get_user_recommend_items_by_hour(data, user_id, hour):
    # 사용자에 대한 추천 아이템 목록을 가져옴
    user_recommendations = get_user_recommendations(data, user_id)

    # TimeRecommendResponse 객체에서 time_slot 속성에 접근하도록 수정
    recommendations = [item for item in user_recommendations if item.time_pattern == hour]

    print(recommendations)

    # 시간대별 추천 리스트 생성
    hour_recommendations = [
        TimeRecommendHourResponse(
            user_id=user_id,
            item_id=item.item_id,
            item_name=item.item_name,
            purchase_count=item.purchase_count
        )
        for item in recommendations
    ]

    return hour_recommendations



def get_all_users_frequent_time_slots(data):
    # user_time_slots = get_frequent_time_slots()
    # time_slots = []

    user_time_slots = get_frequent_time_slots(data, count_threshold=3, max_slots=3)

    time_slots_responses = [
        TimeSlotsResponse(
            user_id=row['user_id'],
            time_slots=row['frequent_time_slots']
        )
        for _, row in user_time_slots.iterrows()
    ]

    return time_slots_responses
