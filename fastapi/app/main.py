from fastapi import FastAPI
import uvicorn
from app.routers import user_router, recommend_router

app = FastAPI()

# 라우터 등록
app.include_router(user_router.router, prefix="/users", tags=["users"])
app.include_router(recommend_router.router, prefix="/recommend", tags=["recommendations"])

if __name__ == "__main__":
    uvicorn.run("app.main:app", host="127.0.0.1", port=8000, reload=True)


@app.get("/")
def read_root():
    return {"message": "Hello, World!"}

