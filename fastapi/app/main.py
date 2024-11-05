from fastapi import FastAPI

app = FastAPI()

@app.get("/recommend")
async def root():
    return {"message": "Welcome to the Repurchase Recommendation System"}
