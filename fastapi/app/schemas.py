from pydantic import BaseModel
from datetime import date

class UserSchema(BaseModel):
    id: int
    email: str
    nickname: str
    gender: str
    birthday: date
    points: int
    password: str  # 실제 응답에서는 보안상 제거하는 것이 좋습니다.

    class Config:
        orm_mode = True
