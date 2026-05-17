from fastapi import FastAPI

from fastapi.middleware.cors import (
    CORSMiddleware
)

from app.database import (
    Base,
    engine
)

# =========================================
# IMPORT MODELS
# =========================================

from app import models

# =========================================
# IMPORT ROUTERS
# =========================================

from app.routers.auth_router import (
    router as auth_router
)

from app.routers.user_router import (
    router as user_router
)

from app.routers.training_router import (
    router as training_router
)

from app.routers.rekomendasi_router import (
    router as rekomendasi_router
)

from app.routers.knn_settings_router import (
    router as knn_settings_router
)

from app.routers.user_input_router import (
    router as user_input_router
)

# =========================================
# FASTAPI APP
# =========================================

app = FastAPI(

    title="SPK KNN API",

    description=
    """
    Sistem Pendukung Keputusan
    Penentuan Bidang Minat
    menggunakan KNN
    """,

    version="1.0.0"
)

# =========================================
# CREATE DATABASE TABLE
# =========================================

Base.metadata.create_all(
    bind=engine
)

# =========================================
# CORS
# =========================================

app.add_middleware(

    CORSMiddleware,

    allow_origins=["*"],

    allow_credentials=True,

    allow_methods=["*"],

    allow_headers=["*"],
)

# =========================================
# ROUTERS
# =========================================

app.include_router(

    auth_router,

    prefix="/auth",

    tags=["Authentication"]
)

app.include_router(

    user_router,

    prefix="/users",

    tags=["Users"]
)

app.include_router(

    training_router,

    prefix="/training",

    tags=["Training Data"]
)

app.include_router(

    user_input_router,

    prefix="/user-input",

    tags=["User Input"]
)

app.include_router(

    rekomendasi_router,

    prefix="/rekomendasi",

    tags=["KNN Prediction"]
)

app.include_router(

    knn_settings_router,

    prefix="/knn-settings",

    tags=["KNN Settings"]
)

# =========================================
# ROOT ENDPOINT
# =========================================

@app.get("/")
def root():

    return {

        "message":
            "SPK KNN API berjalan",

        "version":
            "1.0.0",

        "status":
            "success"
    }


# =========================================
# HEALTH CHECK
# =========================================

@app.get("/health")
def health_check():

    return {

        "status": "healthy"
    }