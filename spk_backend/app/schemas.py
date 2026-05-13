from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional


# =========================================
# AUTH
# =========================================

class LoginSchema(BaseModel):

    email: EmailStr
    password: str


class RegisterSchema(BaseModel):

    username: str
    email: EmailStr
    password: str


# =========================================
# USER RESPONSE
# =========================================

class UserResponse(BaseModel):

    id: int
    username: str
    email: str
    role_id: int

    class Config:
        from_attributes = True


# =========================================
# TRAINING DATA
# =========================================

class TrainingSchema(BaseModel):

    nama: str

    matematika: float
    pemrograman_dasar: float
    basis_data: float
    jaringan_komputer: float
    kecerdasan_buatan: float
    struktur_data: float
    statistika: float
    sistem_operasi: float
    pbo: float

    minat_jurusan: str


class TrainingResponse(BaseModel):

    id: int

    nama: str

    matematika: float
    pemrograman_dasar: float
    basis_data: float
    jaringan_komputer: float
    kecerdasan_buatan: float
    struktur_data: float
    statistika: float
    sistem_operasi: float
    pbo: float

    minat_jurusan: str

    tahun_data: Optional[int]

    created_at: datetime

    class Config:
        from_attributes = True


# =========================================
# PREDICT KNN
# =========================================

class PredictSchema(BaseModel):

    nama: str

    matematika: float
    pemrograman_dasar: float
    basis_data: float
    jaringan_komputer: float
    kecerdasan_buatan: float
    struktur_data: float
    statistika: float
    sistem_operasi: float
    pbo: float


class PredictionResponse(BaseModel):

    nama: str

    hasil_prediksi: str

    nilai_k: int

    class Config:
        from_attributes = True


# =========================================
# HASIL PREDIKSI / HISTORY
# =========================================

class PredictionHistoryResponse(BaseModel):

    id: int

    nama: str

    matematika: float
    pemrograman_dasar: float
    basis_data: float
    jaringan_komputer: float
    kecerdasan_buatan: float
    struktur_data: float
    statistika: float
    sistem_operasi: float
    pbo: float

    hasil_prediksi: str

    nilai_k: Optional[int]

    created_at: datetime

    class Config:
        from_attributes = True


# =========================================
# SETTING NILAI K
# =========================================

class SettingKSchema(BaseModel):

    nilai_k: int


class SettingKResponse(BaseModel):

    id: int
    nilai_k: int
    updated_at: datetime

    class Config:
        from_attributes = True


# =========================================
# KNN CONFIGURATION
# =========================================

class KNNConfigurationRequest(BaseModel):

    k_value: int

    algorithm: str = "KNN"

    distance_metric: str = "Euclidean Distance"

    normalization: str = "Min-Max Scaling"


class KNNConfigurationResponse(BaseModel):

    id: int

    k_value: int

    algorithm: str

    distance_metric: str

    normalization: str

    training_samples: int

    model_accuracy: float

    precision: float

    recall: float

    f1_score: float

    created_at: datetime

    updated_at: datetime

    class Config:
        from_attributes = True


# =========================================
# STATISTIK RESPONSE
# =========================================

class StatistikResponse(BaseModel):

    ai_engineering: int

    cyber_security: int

    rpl: int