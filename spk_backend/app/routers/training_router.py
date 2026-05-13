from fastapi import (
    APIRouter,
    Depends,
    HTTPException
)

from sqlalchemy.orm import Session

from app.database import SessionLocal

from app.models import TrainingData

from app.schemas import (
    TrainingSchema,
    TrainingResponse,
    StatistikResponse
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
# GET ALL TRAINING DATA
# =========================================

@router.get(
    "/",
    response_model=list[TrainingResponse]
)
def get_all_training(
    db: Session = Depends(get_db)
):

    training = db.query(
        TrainingData
    ).all()

    return training


# =========================================
# GET TRAINING BY ID
# =========================================

@router.get(
    "/{training_id}",
    response_model=TrainingResponse
)
def get_training_by_id(
    training_id: int,
    db: Session = Depends(get_db)
):

    training = db.query(
        TrainingData
    ).filter(
        TrainingData.id == training_id
    ).first()

    if not training:

        raise HTTPException(
            status_code=404,
            detail="Training data tidak ditemukan"
        )

    return training


# =========================================
# CREATE TRAINING DATA
# =========================================

@router.post(
    "/",
    response_model=TrainingResponse
)
def add_training(
    data: TrainingSchema,
    db: Session = Depends(get_db)
):

    new_training = TrainingData(

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

        minat_jurusan=data.minat_jurusan
    )

    db.add(new_training)

    db.commit()

    db.refresh(new_training)

    return new_training


# =========================================
# UPDATE TRAINING DATA
# =========================================

@router.put(
    "/{training_id}",
    response_model=TrainingResponse
)
def update_training(
    training_id: int,
    data: TrainingSchema,
    db: Session = Depends(get_db)
):

    training = db.query(
        TrainingData
    ).filter(
        TrainingData.id == training_id
    ).first()

    if not training:

        raise HTTPException(
            status_code=404,
            detail="Training data tidak ditemukan"
        )

    training.nama = data.nama

    training.matematika = data.matematika
    training.pemrograman_dasar = data.pemrograman_dasar
    training.basis_data = data.basis_data
    training.jaringan_komputer = data.jaringan_komputer
    training.kecerdasan_buatan = data.kecerdasan_buatan
    training.struktur_data = data.struktur_data
    training.statistika = data.statistika
    training.sistem_operasi = data.sistem_operasi
    training.pbo = data.pbo

    training.minat_jurusan = data.minat_jurusan

    db.commit()

    db.refresh(training)

    return training


# =========================================
# DELETE TRAINING DATA
# =========================================

@router.delete("/{training_id}")
def delete_training(
    training_id: int,
    db: Session = Depends(get_db)
):

    training = db.query(
        TrainingData
    ).filter(
        TrainingData.id == training_id
    ).first()

    if not training:

        raise HTTPException(
            status_code=404,
            detail="Training data tidak ditemukan"
        )

    db.delete(training)

    db.commit()

    return {
        "message": "Data training berhasil dihapus"
    }


# =========================================
# STATISTIK SUMMARY
# =========================================

@router.get("/stats/summary")
def get_statistics(
    db: Session = Depends(get_db)
):

    total = db.query(
        TrainingData
    ).count()

    rpl = db.query(
        TrainingData
    ).filter(
        TrainingData.minat_jurusan == "RPL"
    ).count()

    ai_engineering = db.query(
        TrainingData
    ).filter(
        TrainingData.minat_jurusan ==
        "AI Engineering"
    ).count()

    cyber_security = db.query(
        TrainingData
    ).filter(
        TrainingData.minat_jurusan ==
        "Cyber Security"
    ).count()

    return {
        "total": total,
        "RPL": rpl,
        "AI Engineering": ai_engineering,
        "Cyber Security": cyber_security
    }


# =========================================
# YEARLY STATISTICS
# =========================================

@router.get("/stats/yearly")
def get_yearly_statistics(
    db: Session = Depends(get_db)
):

    training_data = db.query(
        TrainingData
    ).all()

    yearly_stats = {}

    for data in training_data:

        year = data.tahun_data

        if year not in yearly_stats:

            yearly_stats[year] = {
                "RPL": 0,
                "AI Engineering": 0,
                "Cyber Security": 0
            }

        bidang = data.minat_jurusan

        if bidang in yearly_stats[year]:

            yearly_stats[year][bidang] += 1

    return yearly_stats