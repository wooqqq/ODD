from typing import List
from datetime import datetime

from fastapi import APIRouter, HTTPException
from sqlalchemy.orm import defer

from app.models import PeriodRecommendRequest, PeriodRecommendResponse
from app.models import TimeRecommendRequest, TimeRecommendResponse, TimeSlotsResponse, \
    TimeRecommendHourRequest, TimeRecommendHourResponse
from app.models import CategoryRecommendationResponse, \
    CategoryRecommendationRequest, RecommendationPlatformRequest
from app.services.data_loader import load_data, load_data_by_user, load_logs_data
from app.services.recommendations.period_recommend import calculate_recommendation_for_items, \
    calculate_recommendations_for_all_users, filter_recommendations_by_date
from app.services.recommendations.time_similar_recommend import get_user_recommendations, \
    get_all_users_frequent_time_slots, get_user_recommend_items_by_hour
from app.services.recommendations.category_recommend import recommend_new_user, hybrid_recommendation
import pandas as pd

router = APIRouter()

TODAY = datetime.today()


# /recommendation/ 엔드포인트 정의
@router.post("/period", response_model=list[PeriodRecommendResponse])
async def get_recommendation_by_period(request: PeriodRecommendRequest):
    # 데이터 로드 및 필터링 예시
    data = load_data_by_user('period_recommend_data', request.user_id)

    # data = pd.read_csv('combined_log_data.csv', parse_dates=['event_time'], low_memory=False)
    data['event_time'] = pd.to_datetime(data['event_time'], errors='coerce')
    is_target_user = data['user_id'] == request.user_id
    is_order = data['inter'] == 'order'
    is_valid_service = data['service'].isin(['mart_pickup', 'mart_dlvy'])

    user_purchases = data[is_target_user & is_order & is_valid_service]

    # 추천 계산
    if user_purchases.empty:
        raise HTTPException(status_code=404, detail="No purchase data found for the given user.")

    recommendations = calculate_recommendation_for_items(request.user_id, user_purchases)

    return recommendations

@router.get("/period/all", response_model=List[PeriodRecommendResponse])
async def get_recommendations_for_all_users():
    # 전체 데이터 로드
    data = load_data('period_recommend_data')

    first_data = calculate_recommendations_for_all_users(data)

    # 추천 날짜 기준으로 필터링
    filtered_data = filter_recommendations_by_date(first_data, TODAY)

    # 결과 반환
    recommendations = filtered_data.to_dict(orient='records')
    return recommendations


# 추천 API 엔드포인트
@router.post("/user-time-recommend", response_model=List[TimeRecommendResponse])
async def get_recommendation_by_time(request: TimeRecommendRequest):
    # 임시 데이터 => 더미 데이터 생성 후 테이블명 바꿔야 함
    data = load_data_by_user('time_recommend_data', request.user_id)

    # 추천 로직 호출
    recommendations = get_user_recommendations(data, request.user_id)

    # 추천 결과가 없는 경우 예외 발생
    if not recommendations:
        raise HTTPException(
            status_code=404,
            detail=f"No recommendations available for {TODAY}. Please try again later."
        )

    return recommendations

@router.post("/user-hour-recommend", response_model=List[TimeRecommendHourResponse])
async def get_recommend_user_by_hour(request: TimeRecommendHourRequest):
    data = load_data_by_user('time_recommend_data', request.user_id)

    recommendations = get_user_recommend_items_by_hour(data, request.user_id, request.hour)

    # 추천 결과가 없는 경우 예외 발생
    if not recommendations:
        raise HTTPException(
            status_code=404,
            detail=f"No recommendations available for {TODAY}. Please try again later."
        )

    return recommendations


@router.get("/user-time-slots", response_model=List[TimeSlotsResponse])
async def get_user_time_slots():
    data = load_data('time_recommend_data')

    # 전체 사용자에 대해 자주 이용하는 시간대 정보를 가져옴
    user_time_slots = get_all_users_frequent_time_slots(data)

    # 결과 반환
    return user_time_slots

@router.post("/new-user-category", response_model=List[CategoryRecommendationResponse])
async def new_user_category_recommendation(request: CategoryRecommendationRequest):
    try:
        print(
            f"Received new user request: user_id={request.user_id}, platform={request.platform}, categories={request.new_user_category}")
        data = load_data('logs')  # 로그 데이터 테이블 이름
        recommendations = recommend_new_user(request.new_user_category, request.platform, data)
        if not recommendations['items']:
            raise HTTPException(status_code=404, detail="No recommendations available for new user")
        return recommendations['items']
    except Exception as e:
        print(f"An error occurred: {e}")
        raise HTTPException(status_code=500, detail=f"An unexpected error occurred: {str(e)}")


@router.post("/existing-user-category", response_model=List[CategoryRecommendationResponse])
async def existing_user_category_recommendation(request: RecommendationPlatformRequest):
    try:
        # 요청 수신 로그 출력
        print(f"Received request: user_id={request.user_id}, platform={request.platform}")

        # 전체 로그 데이터를 불러옴
        data = load_logs_data()
        print("Initial logs data columns:", data.columns)
        print("Sample logs data:", data.head())

        if data.empty:
            print("Logs data is empty.")
            raise HTTPException(status_code=404, detail="Logs data is empty.")

        # 특정 user_id로 필터링
        user_data = data[data['user_id'] == request.user_id]
        if user_data.empty:
            print("No data found for the given user.")
            print("Available user IDs in data:", data['user_id'].unique())  # 사용 가능한 user_id 목록 출력
            raise HTTPException(status_code=404, detail="No data found for the given user.")

        print("Data loaded successfully. Sample data:\n", user_data.head())

        print("Data loaded successfully. Sample data:\n", user_data.head())
        recommendations = hybrid_recommendation(request.user_id, request.platform, user_data)
        if not recommendations or 'items' not in recommendations or not recommendations['items']:
            print("No recommendations available for this user.")
            raise HTTPException(status_code=404, detail="No recommendations available for existing user")

        print("Returning recommendations.")
        print(f"Sample recommendation response: {recommendations['items'][0]}")
        return recommendations['items']
    except Exception as e:
        print(f"An error occurred: {e}")
        raise HTTPException(status_code=500, detail=f"An unexpected error occurred: {str(e)}")