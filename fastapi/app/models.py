from typing import Optional, List

from sqlalchemy import Column, Integer, String, Date
from app.database import Base
from pydantic import BaseModel

class User(Base):
    __tablename__ = "user"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(255), unique=True, index=True)
    nickname = Column(String(255))
    gender = Column(String(255))
    birthday = Column(Date)
    points = Column(Integer)
    password = Column(String(255))


# Pydantic 모델로 요청 받을 데이터 정의
class PeriodRecommendRequest(BaseModel):
    user_id: str


class TimeRecommendRequest(BaseModel):
    user_id: str

class TimeRecommendHourRequest(BaseModel):
    user_id: str
    hour: int

class RecommendationPlatformRequest(BaseModel):
    user_id: str
    platform: str


class CategoryRecommendationRequest(BaseModel):
    user_id: str
    platform: str
    new_user_category: List[str] = []


class PeriodRecommendResponse(BaseModel):
    user_id: str
    item_id: str
    item_name: str
    recommendation_date: str
    purchase_dates: List[str]


class CategoryRecommendationResponse(BaseModel):
    itemId: str
    platform: str
    serviceType: List[str]
    price: float
    s3url: Optional[str]  # Allow for None values
    itemName: str


class TimeRecommendResponse(BaseModel):
    user_id: str
    time_pattern: int
    item_id: str
    item_name: str
    purchase_count: int

class TimeRecommendHourResponse(BaseModel):
    user_id: str
    item_id: str
    item_name: str
    purchase_count: int


class TimeSlotsResponse(BaseModel):
    user_id: str
    time_slots: List[int]