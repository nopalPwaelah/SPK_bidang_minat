from sqlalchemy import Column, Integer, String, Float, ForeignKey
from app.database import Base

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True)
    username = Column(String(100))
    email = Column(String(100))
    password = Column(String(255))
    role_id = Column(Integer)

class Mahasiswa(Base):
    __tablename__ = "mahasiswa"
    id = Column(Integer, primary_key=True)
    nama = Column(String(100))
    ipk = Column(Float)

class NilaiMahasiswa(Base):
    __tablename__ = "nilai_mahasiswa"
    id = Column(Integer, primary_key=True)
    mahasiswa_id = Column(Integer, ForeignKey("mahasiswa.id"))
    kriteria_id = Column(Integer)
    nilai = Column(Float)

class TrainingData(Base):
    __tablename__ = "training_data"
    id = Column(Integer, primary_key=True)
    nama = Column(String(100))
    ipk = Column(Float)
    bidang_minat = Column(String(50))

class TrainingNilai(Base):
    __tablename__ = "training_nilai"
    id = Column(Integer, primary_key=True)
    training_id = Column(Integer)
    kriteria_id = Column(Integer)
    nilai = Column(Float)