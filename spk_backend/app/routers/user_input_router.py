from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import List, Dict, Any, Optional
from app.services.csv_service import (
    add_input_user, get_input_users, process_training
)
from app.services.nilai_converter import convert_nilai
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models import TrainingData

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
# SCHEMAS
# =========================================

class InputUserSchema(BaseModel):
    nama: str
    tahun: int
    ipk: float | str  # Bisa huruf atau angka
    pemrograman: float | str
    basis_data: float | str
    cyber_security: float | str
    ai: float | str
    bidang_minat: str


class PredictionRequest(BaseModel):
    ipk: float | str
    pemrograman: float | str
    basis_data: float | str
    cyber_security: float | str
    ai: float | str
    k: int = 3


# =========================================
# INPUT USER ENDPOINTS
# =========================================

@router.post("/")
def input_user(data: InputUserSchema):
    """Input data user baru"""
    try:
        success = add_input_user(data.dict())
        if not success:
            raise HTTPException(status_code=400, detail="Gagal menambah data input user")

        return {
            "message": "Data berhasil masuk ke input user",
            "data": data.dict()
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error: {str(e)}")


@router.get("/")
def get_input():
    """Ambil semua data input user"""
    try:
        data = get_input_users()
        return {
            "message": "Data berhasil diambil",
            "data": data,
            "total": len(data)
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error: {str(e)}")


@router.delete("/{index}")
def delete_input(index: int):
    """Hapus data input user berdasarkan index"""
    try:
        from app.services.csv_service import delete_input_user
        success = delete_input_user(index)
        if not success:
            raise HTTPException(status_code=404, detail="Data input user tidak ditemukan")

        return {"message": "Data input user berhasil dihapus"}
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error: {str(e)}")


# =========================================
# TRAINING ENDPOINTS
# =========================================

@router.post("/train")
def train_model():
    """Pindahkan data input user ke training data"""
    try:
        success = process_training()
        if not success:
            raise HTTPException(status_code=400, detail="Tidak ada data untuk training atau terjadi error")

        return {
            "message": "Training berhasil, data telah dipindahkan ke training data"
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error: {str(e)}")


# =========================================
# PREDICTION ENDPOINTS
# =========================================

@router.post("/predict")
def predict_bidang(data: PredictionRequest):
    """Prediksi bidang minat berdasarkan nilai"""
    try:
        # Validate and convert input values
        try:
            ipk = convert_nilai(data.ipk)
            pemrograman = convert_nilai(data.pemrograman)
            basis_data = convert_nilai(data.basis_data)
            cyber_security = convert_nilai(data.cyber_security)
            ai = convert_nilai(data.ai)
        except ValueError as e:
            raise HTTPException(status_code=400, detail=f"Format error: {str(e)}")

        input_features = [
            ipk, pemrograman, basis_data,
            cyber_security, ai
        ]

        from app.services.knn_service import knn_predict
        from app.services.csv_service import get_training_data
        
        training_data = get_training_data()
        if not training_data:
            raise HTTPException(status_code=400, detail="Tidak ada data training")

        result = knn_predict(training_data, input_features, data.k)
        if "error" in result:
            raise HTTPException(status_code=400, detail=result["error"])

        return result
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error: {str(e)}")


# =========================================
# METRICS ENDPOINTS
# =========================================

@router.get("/metrics")
def get_metrics(k: int = 3):
    """Ambil metrics model KNN"""
    try:
        from app.services.knn_service import calculate_model_metrics
        return calculate_model_metrics(k)
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error: {str(e)}")


@router.get("/optimal-k")
def get_optimal_k(max_k: int = 10):
    """Cari nilai K optimal"""
    from app.services.knn_service import get_optimal_k
    return get_optimal_k(max_k)