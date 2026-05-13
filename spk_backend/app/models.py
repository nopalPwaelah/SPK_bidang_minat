from sqlalchemy import (
    Column,
    Integer,
    String,
    Float,
    ForeignKey,
    DateTime
)

from sqlalchemy.orm import relationship

from datetime import datetime

from app.database import Base


# =========================================
# USER
# =========================================

class User(Base):

    __tablename__ = "users"

    id = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )

    username = Column(
        String(100),
        nullable=False
    )

    email = Column(
        String(100),
        unique=True,
        nullable=False
    )

    password = Column(
        String(255),
        nullable=False
    )

    role_id = Column(
        Integer,
        default=2
    )


# =========================================
# MAHASISWA
# =========================================

class Mahasiswa(Base):

    __tablename__ = "mahasiswa"

    id = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )

    nama = Column(
        String(100),
        nullable=False
    )

    ipk = Column(Float)

    created_at = Column(
        DateTime,
        default=datetime.utcnow
    )

    # RELATION
    nilai = relationship(
        "NilaiMahasiswa",
        back_populates="mahasiswa",
        cascade="all, delete"
    )


# =========================================
# NILAI MAHASISWA
# =========================================

class NilaiMahasiswa(Base):

    __tablename__ = "nilai_mahasiswa"

    id = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )

    mahasiswa_id = Column(
        Integer,
        ForeignKey("mahasiswa.id")
    )

    kriteria_id = Column(Integer)

    nilai = Column(Float)

    mahasiswa = relationship(
        "Mahasiswa",
        back_populates="nilai"
    )


# =========================================
# TRAINING DATA KNN
# =========================================

class TrainingData(Base):

    __tablename__ = "training_data"

    id = Column(
        Integer,
        primary_key=True,
        index=True
    )

    nama = Column(
        String(100),
        nullable=False
    )

    matematika = Column(Float)
    pemrograman_dasar = Column(Float)
    basis_data = Column(Float)
    jaringan_komputer = Column(Float)
    kecerdasan_buatan = Column(Float)
    struktur_data = Column(Float)
    statistika = Column(Float)
    sistem_operasi = Column(Float)
    pbo = Column(Float)

    minat_jurusan = Column(
        String(100),
        nullable=False
    )

    tahun_data = Column(
        Integer,
        default=2026
    )

    created_at = Column(
        DateTime,
        default=datetime.utcnow
    )


# =========================================
# SETTING NILAI K
# =========================================

class SettingK(Base):

    __tablename__ = "setting_k"

    id = Column(
        Integer,
        primary_key=True,
        index=True
    )

    nilai_k = Column(
        Integer,
        default=3
    )

    updated_at = Column(
        DateTime,
        default=datetime.utcnow,
        onupdate=datetime.utcnow
    )


# =========================================
# HASIL PREDIKSI
# =========================================

class PredictionResult(Base):

    __tablename__ = "prediction_result"

    id = Column(
        Integer,
        primary_key=True,
        index=True
    )

    nama = Column(
        String(100),
        nullable=False
    )

    matematika = Column(Float)
    pemrograman_dasar = Column(Float)
    basis_data = Column(Float)
    jaringan_komputer = Column(Float)
    kecerdasan_buatan = Column(Float)
    struktur_data = Column(Float)
    statistika = Column(Float)
    sistem_operasi = Column(Float)
    pbo = Column(Float)

    hasil_prediksi = Column(
        String(100),
        nullable=False
    )

    nilai_k = Column(Integer)

    created_at = Column(
        DateTime,
        default=datetime.utcnow
    )


# =========================================
# KNN CONFIGURATION
# =========================================

class KNNConfiguration(Base):

    __tablename__ = "knn_configuration"

    id = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )

    k_value = Column(
        Integer,
        default=3
    )

    algorithm = Column(
        String(50),
        default="KNN"
    )

    distance_metric = Column(
        String(50),
        default="Euclidean Distance"
    )

    normalization = Column(
        String(50),
        default="Min-Max Scaling"
    )

    training_samples = Column(
        Integer,
        default=0
    )

    model_accuracy = Column(
        Float,
        default=0.0
    )

    precision = Column(
        Float,
        default=0.0
    )

    recall = Column(
        Float,
        default=0.0
    )

    f1_score = Column(
        Float,
        default=0.0
    )

    created_at = Column(
        DateTime,
        default=datetime.utcnow
    )

    updated_at = Column(
        DateTime,
        default=datetime.utcnow,
        onupdate=datetime.utcnow
    )