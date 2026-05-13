from fastapi import (
    APIRouter,
    Depends,
    HTTPException
)

from sqlalchemy.orm import Session

from sklearn.neighbors import KNeighborsClassifier

from sklearn.preprocessing import (
    MinMaxScaler,
    LabelEncoder
)

from sklearn.metrics import (
    precision_score,
    recall_score,
    f1_score,
    accuracy_score
)

import pandas as pd
import numpy as np

from app.database import SessionLocal

from app.models import (
    KNNConfiguration,
    TrainingData
)

from app.schemas import (
    KNNConfigurationRequest,
    KNNConfigurationResponse,
    SettingKSchema
)

router = APIRouter()


# =========================================
# DATABASE SESSION
# =========================================

def get_db():

    db = SessionLocal()

    try:
        yield db

    finally:
        db.close()


# =========================================
# GET OR CREATE CONFIG
# =========================================

def get_or_create_config(
    db: Session
):

    config = db.query(
        KNNConfiguration
    ).first()

    if not config:

        config = KNNConfiguration()

        db.add(config)

        db.commit()

        db.refresh(config)

    return config


# =========================================
# CALCULATE KNN METRICS
# =========================================

def calculate_metrics(
    db: Session,
    k_value: int
):

    training_data = db.query(
        TrainingData
    ).all()

    if len(training_data) < 2:

        return {
            "accuracy": 0,
            "precision": 0,
            "recall": 0,
            "f1": 0,
            "samples": 0
        }

    dataset = []

    for item in training_data:

        dataset.append({

            "matematika":
                item.matematika,

            "pemrograman_dasar":
                item.pemrograman_dasar,

            "basis_data":
                item.basis_data,

            "jaringan_komputer":
                item.jaringan_komputer,

            "kecerdasan_buatan":
                item.kecerdasan_buatan,

            "struktur_data":
                item.struktur_data,

            "statistika":
                item.statistika,

            "sistem_operasi":
                item.sistem_operasi,

            "pbo":
                item.pbo,

            "minat_jurusan":
                item.minat_jurusan
        })

    df = pd.DataFrame(dataset)

    features = [

        "matematika",
        "pemrograman_dasar",
        "basis_data",
        "jaringan_komputer",
        "kecerdasan_buatan",
        "struktur_data",
        "statistika",
        "sistem_operasi",
        "pbo"
    ]

    X = df[features]

    y = df["minat_jurusan"]

    # =========================
    # LABEL ENCODER
    # =========================

    encoder = LabelEncoder()

    y_encoded = encoder.fit_transform(y)

    # =========================
    # NORMALIZATION
    # =========================

    scaler = MinMaxScaler()

    X_scaled = scaler.fit_transform(X)

    # =========================
    # VALIDASI K
    # =========================

    if k_value >= len(X_scaled):

        k_value = max(
            1,
            len(X_scaled) - 1
        )

    # =========================
    # TRAIN MODEL
    # =========================

    model = KNeighborsClassifier(
        n_neighbors=k_value
    )

    model.fit(
        X_scaled,
        y_encoded
    )

    # =========================
    # PREDICT TRAINING
    # =========================

    y_pred = model.predict(
        X_scaled
    )

    # =========================
    # METRICS
    # =========================

    accuracy = accuracy_score(
        y_encoded,
        y_pred
    )

    precision = precision_score(
        y_encoded,
        y_pred,
        average='weighted',
        zero_division=0
    )

    recall = recall_score(
        y_encoded,
        y_pred,
        average='weighted',
        zero_division=0
    )

    f1 = f1_score(
        y_encoded,
        y_pred,
        average='weighted',
        zero_division=0
    )

    return {

        "accuracy":
            float(accuracy * 100),

        "precision":
            float(precision * 100),

        "recall":
            float(recall * 100),

        "f1":
            float(f1 * 100),

        "samples":
            len(training_data)
    }


# =========================================
# GET CONFIGURATION
# =========================================

@router.get(
    "/configuration",
    response_model=
        KNNConfigurationResponse
)
def get_configuration(
    db: Session = Depends(get_db)
):

    config = get_or_create_config(
        db
    )

    return config


# =========================================
# UPDATE CONFIGURATION
# =========================================

@router.put(
    "/configuration",
    response_model=
        KNNConfigurationResponse
)
def update_configuration(
    req: KNNConfigurationRequest,
    db: Session = Depends(get_db)
):

    config = get_or_create_config(
        db
    )

    metrics = calculate_metrics(
        db,
        req.k_value
    )

    config.k_value = req.k_value

    config.algorithm = req.algorithm

    config.distance_metric = (
        req.distance_metric
    )

    config.normalization = (
        req.normalization
    )

    config.training_samples = (
        metrics["samples"]
    )

    config.model_accuracy = (
        metrics["accuracy"]
    )

    config.precision = (
        metrics["precision"]
    )

    config.recall = (
        metrics["recall"]
    )

    config.f1_score = (
        metrics["f1"]
    )

    db.commit()

    db.refresh(config)

    return config


# =========================================
# GET K VALUE
# =========================================

@router.get("/k")
def get_k(
    db: Session = Depends(get_db)
):

    config = get_or_create_config(
        db
    )

    return {
        "k": config.k_value
    }


# =========================================
# UPDATE K VALUE
# =========================================

@router.put("/k")
def set_k(
    data: SettingKSchema,
    db: Session = Depends(get_db)
):

    config = get_or_create_config(
        db
    )

    metrics = calculate_metrics(
        db,
        data.nilai_k
    )

    config.k_value = data.nilai_k

    config.training_samples = (
        metrics["samples"]
    )

    config.model_accuracy = (
        metrics["accuracy"]
    )

    config.precision = (
        metrics["precision"]
    )

    config.recall = (
        metrics["recall"]
    )

    config.f1_score = (
        metrics["f1"]
    )

    db.commit()

    db.refresh(config)

    return {

        "message":
            "Nilai K berhasil diupdate",

        "k": config.k_value,

        "accuracy":
            config.model_accuracy
    }


# =========================================
# GET METRICS
# =========================================

@router.get("/metrics")
def get_metrics(
    db: Session = Depends(get_db)
):

    config = get_or_create_config(
        db
    )

    return {

        "training_samples":
            config.training_samples,

        "model_accuracy":
            config.model_accuracy,

        "precision":
            config.precision,

        "recall":
            config.recall,

        "f1_score":
            config.f1_score,

        "algorithm":
            config.algorithm,

        "distance_metric":
            config.distance_metric,

        "normalization":
            config.normalization
    }