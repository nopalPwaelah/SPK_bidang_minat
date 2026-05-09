from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from pydantic import BaseModel
from app.database import SessionLocal
from app.models import TrainingData

router = APIRouter()

class TrainingRequest(BaseModel):
    nama: str
    ipk: float
    bidang_minat: str

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ================= GET ALL TRAINING DATA =================
@router.get("/")
def get_all_training(db: Session = Depends(get_db)):
    """Ambil semua data training dari database"""
    training = db.query(TrainingData).all()
    return training

# ================= GET SINGLE TRAINING DATA =================
@router.get("/{training_id}")
def get_training_by_id(training_id: int, db: Session = Depends(get_db)):
    """Ambil satu data training berdasarkan ID"""
    training = db.query(TrainingData).filter(TrainingData.id == training_id).first()
    if not training:
        return {"error": "Training data tidak ditemukan"}
    return training

# ================= ADD NEW TRAINING DATA =================
@router.post("/")
def add_training(data: TrainingRequest, db: Session = Depends(get_db)):
    """Tambah data training baru ke database"""
    new_training = TrainingData(
        nama=data.nama,
        ipk=data.ipk,
        bidang_minat=data.bidang_minat
    )
    db.add(new_training)
    db.commit()
    db.refresh(new_training)
    return {
        "message": "Data training berhasil ditambahkan",
        "data": {
            "id": new_training.id,
            "nama": new_training.nama,
            "ipk": new_training.ipk,
            "bidang_minat": new_training.bidang_minat
        }
    }

# ================= UPDATE TRAINING DATA =================
@router.put("/{training_id}")
def update_training(training_id: int, data: TrainingRequest, db: Session = Depends(get_db)):
    """Update data training berdasarkan ID"""
    training = db.query(TrainingData).filter(TrainingData.id == training_id).first()
    
    if not training:
        return {"error": "Training data tidak ditemukan"}
    
    training.nama = data.nama
    training.ipk = data.ipk
    training.bidang_minat = data.bidang_minat
    
    db.commit()
    db.refresh(training)
    
    return {
        "message": "Data training berhasil diupdate",
        "data": {
            "id": training.id,
            "nama": training.nama,
            "ipk": training.ipk,
            "bidang_minat": training.bidang_minat
        }
    }

# ================= DELETE TRAINING DATA =================
@router.delete("/{training_id}")
def delete_training(training_id: int, db: Session = Depends(get_db)):
    """Hapus data training berdasarkan ID"""
    training = db.query(TrainingData).filter(TrainingData.id == training_id).first()
    
    if not training:
        return {"error": "Training data tidak ditemukan"}
    
    db.delete(training)
    db.commit()
    
    return {"message": "Data training berhasil dihapus"}

# ================= GET STATISTICS =================
@router.get("/stats/summary")
def get_statistics(db: Session = Depends(get_db)):
    """Ambil statistik total training data"""
    total = db.query(TrainingData).count()
    rpl = db.query(TrainingData).filter(TrainingData.bidang_minat == "RPL").count()
    jaringan = db.query(TrainingData).filter(TrainingData.bidang_minat == "Jaringan").count()
    iot = db.query(TrainingData).filter(TrainingData.bidang_minat == "IoT").count()
    
    return {
        "total": total,
        "RPL": rpl,
        "Jaringan": jaringan,
        "IoT": iot
    }

# ================= GET YEARLY STATISTICS =================
@router.get("/stats/yearly")
def get_yearly_statistics(db: Session = Depends(get_db)):
    """Ambil statistik training data per tahun"""
    from datetime import datetime
    
    training_data = db.query(TrainingData).all()
    
    # Initialize years 2022-2025
    yearly_stats = {
        2022: {"RPL": 0, "Jaringan": 0, "IoT": 0},
        2023: {"RPL": 0, "Jaringan": 0, "IoT": 0},
        2024: {"RPL": 0, "Jaringan": 0, "IoT": 0},
        2025: {"RPL": 0, "Jaringan": 0, "IoT": 0},
    }
    
    # Count by year and bidang
    for data in training_data:
        # Assign ke tahun berdasarkan created_at atau default 2025
        if hasattr(data, 'created_at') and data.created_at:
            year = data.created_at.year
        else:
            year = 2025
        
        # Ensure year in yearly_stats
        if year not in yearly_stats:
            yearly_stats[year] = {"RPL": 0, "Jaringan": 0, "IoT": 0}
        
        # Count by bidang_minat
        bidang = data.bidang_minat if data.bidang_minat else "RPL"
        if bidang in yearly_stats[year]:
            yearly_stats[year][bidang] += 1
    
    return yearly_stats
