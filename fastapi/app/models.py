from sqlalchemy import Column, Integer, String, Date
from .database import Base

class User(Base):
    __tablename__ = "user"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(255), unique=True, index=True)
    nickname = Column(String(255))
    gender = Column(String(255))
    birthday = Column(Date)
    points = Column(Integer)
    password = Column(String(255))
