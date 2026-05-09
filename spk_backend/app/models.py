from sqlalchemy import Column, Integer, String, Float, ForeignKey, DateTime
from app.database import Base
from datetime import datetime

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, autoincrement=True)
    username = Column(String(100))
    email = Column(String(100))
    password = Column(String(255))
    role_id = Column(Integer)

class Mahasiswa(Base):
    __tablename__ = "mahasiswa"
    id = Column(Integer, primary_key=True, autoincrement=True)
    nama = Column(String(100))
    ipk = Column(Float)

class NilaiMahasiswa(Base):
    __tablename__ = "nilai_mahasiswa"
    id = Column(Integer, primary_key=True, autoincrement=True)
    mahasiswa_id = Column(Integer, ForeignKey("mahasiswa.id"))
    kriteria_id = Column(Integer)
    nilai = Column(Float)

class TrainingData(Base):
    __tablename__ = "training_data"
    id = Column(Integer, primary_key=True, autoincrement=True)
    nama = Column(String(100))
    ipk = Column(Float)
    bidang_minat = Column(String(50))

class TrainingNilai(Base):
    __tablename__ = "training_nilai"
    id = Column(Integer, primary_key=True, autoincrement=True)
    training_id = Column(Integer)
    kriteria_id = Column(Integer)
    nilai = Column(Float)

class KNNConfiguration(Base):
    __tablename__ = "knn_configuration"
    id = Column(Integer, primary_key=True, autoincrement=True)
    k_value = Column(Integer, default=3)
    algorithm = Column(String(50), default="KNN")
    distance_metric = Column(String(50), default="Euclidean Distance")
    normalization = Column(String(50), default="Min-Max Scaling")
    training_samples = Column(Integer, default=0)
    model_accuracy = Column(Float, default=0.0)
    precision = Column(Float, default=0.0)
    recall = Column(Float, default=0.0)
    f1_score = Column(Float, default=0.0)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)