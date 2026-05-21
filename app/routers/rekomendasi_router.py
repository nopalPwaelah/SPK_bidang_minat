from fastapi import (
    APIRouter,
    Depends,
    HTTPException
)

from sqlalchemy.orm import Session

from sklearn.neighbors import KNeighborsClassifier
from sklearn.preprocessing import LabelEncoder

import pandas as pd
import numpy as np

from app.database import SessionLocal

from app.models import (
    TrainingData,
    PredictionResult,
    SettingK
)

from app.schemas import (
    PredictSchema,
    PredictionResponse,
    PredictionHistoryResponse
)

from app.services.nilai_converter import convert_nilai

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
# PREDICT KNN
# =========================================

@router.post(
    "/predict",
    response_model=PredictionResponse
)
def predict_knn(
    data: PredictSchema,
    db: Session = Depends(get_db)
):
    try:
        # =========================
        # AMBIL TRAINING DATA
        # =========================

        training_data = db.query(
            TrainingData
        ).all()

        if not training_data:
            raise HTTPException(
                status_code=404,
                detail="Training data kosong"
            )

        dataset = []

        for item in training_data:
            dataset.append({
                "matematika": item.matematika,
                "pemrograman_dasar": item.pemrograman_dasar,
                "basis_data": item.basis_data,
                "jaringan_komputer": item.jaringan_komputer,
                "kecerdasan_buatan": item.kecerdasan_buatan,
                "struktur_data": item.struktur_data,
                "statistika": item.statistika,
                "sistem_operasi": item.sistem_operasi,
                "pbo": item.pbo,
                "minat_jurusan": item.minat_jurusan
            })

        # =========================
        # DATAFRAME
        # =========================

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
        # AMBIL NILAI K
        # =========================

        setting_k = db.query(SettingK).first()
        nilai_k = 3

        if setting_k:
            nilai_k = setting_k.nilai_k

        # =========================
        # TRAIN MODEL
        # =========================

        model = KNeighborsClassifier(n_neighbors=nilai_k)
        model.fit(X, y_encoded)

        # =========================
        # INPUT USER - CONVERT WITH ERROR HANDLING
        # =========================

        input_user = [[
            convert_nilai(data.matematika),
            convert_nilai(data.pemrograman_dasar),
            convert_nilai(data.basis_data),
            convert_nilai(data.jaringan_komputer),
            convert_nilai(data.kecerdasan_buatan),
            convert_nilai(data.struktur_data),
            convert_nilai(data.statistika),
            convert_nilai(data.sistem_operasi),
            convert_nilai(data.pbo)
        ]]

        # =========================
        # PREDICT
        # =========================

        prediction = model.predict(input_user)
        hasil = encoder.inverse_transform(prediction)
        hasil_prediksi = hasil[0]

        # =========================
        # SAVE HISTORY
        # =========================

        save_result = PredictionResult(
            nama=data.nama,
            matematika=data.matematika,
            pemrograman_dasar=data.pemrograman_dasar,
            basis_data=data.basis_data,
            jaringan_komputer=data.jaringan_komputer,
            kecerdasan_buatan=data.kecerdasan_buatan,
            struktur_data=data.struktur_data,
            statistika=data.statistika,
            sistem_operasi=data.sistem_operasi,
            pbo=data.pbo,
            hasil_prediksi=hasil_prediksi,
            nilai_k=nilai_k
        )

        db.add(save_result)
        db.commit()

        return {
            "nama": data.nama,
            "hasil_prediksi": hasil_prediksi,
            "nilai_k": nilai_k
        }
    
    except ValueError as e:
        raise HTTPException(
            status_code=400,
            detail=f"Format error pada nilai: {str(e)}"
        )
    except Exception as e:
        raise HTTPException(
            status_code=400,
            detail=f"Error dalam prediksi: {str(e)}"
        )


# =========================================
# GET HISTORY PREDICTION
# =========================================

@router.get(
    "/history",
    response_model=list[
        PredictionHistoryResponse
    ]
)
def get_history(
    db: Session = Depends(get_db)
):

    history = db.query(
        PredictionResult
    ).all()

    return history


# =========================================
# DELETE HISTORY
# =========================================

@router.delete("/history/{history_id}")
def delete_history(
    history_id: int,
    db: Session = Depends(get_db)
):

    history = db.query(
        PredictionResult
    ).filter(
        PredictionResult.id == history_id
    ).first()

    if not history:

        raise HTTPException(
            status_code=404,
            detail="History tidak ditemukan"
        )

    db.delete(history)

    db.commit()

    return {
        "message":
            "History berhasil dihapus"
    }


# =========================================
# GET TOTAL HISTORY
# =========================================

@router.get("/history/summary")
def history_summary(
    db: Session = Depends(get_db)
):

    total = db.query(
        PredictionResult
    ).count()

    ai = db.query(
        PredictionResult
    ).filter(
        PredictionResult.hasil_prediksi
        == "AI Engineering"
    ).count()

    cyber = db.query(
        PredictionResult
    ).filter(
        PredictionResult.hasil_prediksi
        == "Cyber Security"
    ).count()

    rpl = db.query(
        PredictionResult
    ).filter(
        PredictionResult.hasil_prediksi
        == "RPL"
    ).count()

    return {

        "total_prediction": total,

        "AI Engineering": ai,

        "Cyber Security": cyber,

        "RPL": rpl
    }