from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from ..database import get_db
from ..models import User
from ..schemas import UserSchema

router = APIRouter()

@router.get("/users", response_model=list[UserSchema])
def read_users(db: Session = Depends(get_db)):
    users = db.query(User).all()
    return users
