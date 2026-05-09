from pydantic import BaseModel
from datetime import datetime

class LoginSchema(BaseModel):
    email: str
    password: str

class RegisterSchema(BaseModel):
    username: str
    email: str
    password: str

class KNNRequest(BaseModel):
    mahasiswa_id: int
    k: int = 3

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