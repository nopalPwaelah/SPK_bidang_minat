from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from pydantic import BaseModel  # <-- Tambahkan ini
from app.database import SessionLocal
from app.models import NilaiMahasiswa, TrainingData, TrainingNilai # Sebaiknya spesifik
from app.schemas import KNNRequest
from app.knn import knn # Pastikan di file knn.py ada def knn(...)

router = APIRouter()

class NilaiRequest(BaseModel):
    ipk: float
    algoritma: float
    basis_data: float

@router.post("/")
def proses_knn(data: NilaiRequest):
    # Pastikan fungsi knn di file knn.py menerima 3 parameter ini
    # Jika di knn.py namanya 'hitung_knn', ganti baris ini atau ganti importnya
    hasil, detail = knn(
        data.ipk,
        data.algoritma,
        data.basis_data
    )

    return {
        "hasil": hasil,
        "detail": detail
    }

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/recommendation")
def rekomendasi(data: KNNRequest, db: Session = Depends(get_db)):
    nilai_mhs = db.query(NilaiMahasiswa).filter_by(mahasiswa_id=data.mahasiswa_id).all()
    test = [n.nilai for n in nilai_mhs]

    training = db.query(TrainingData).all()
    data_train = []
    labels = []

    for t in training:
        nilai = db.query(TrainingNilai).filter_by(training_id=t.id).all()
        data_train.append([n.nilai for n in nilai])
        labels.append(t.bidang_minat)

    # Pastikan fungsi knn sanggup menerima 4 argumen ini
    hasil = knn(data_train, labels, test, data.k)

    return {"hasil": hasil}