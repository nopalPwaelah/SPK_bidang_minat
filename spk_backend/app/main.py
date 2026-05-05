from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database import Base, engine

from app.routers import (
    auth_router,
    user_router,
    rekomendasi_router,
    training_router
)

app = FastAPI(
    title="SPK KNN API",
    version="1.0.0"
)

Base.metadata.create_all(bind=engine)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth_router, prefix="/auth", tags=["Auth"])
app.include_router(user_router, prefix="/user", tags=["Users"])
app.include_router(training_router, prefix="/training", tags=["Training"])
app.include_router(rekomendasi_router, prefix="/knn", tags=["KNN"])

@app.get("/")
def root():
    return {"msg": "API jalan "}