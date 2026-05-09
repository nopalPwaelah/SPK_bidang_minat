from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from pydantic import BaseModel
from app.database import SessionLocal
from app.models import KNNConfiguration, TrainingData, TrainingNilai
from app.schemas import KNNConfigurationRequest, KNNConfigurationResponse
from sklearn.neighbors import KNeighborsClassifier
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import precision_score, recall_score, f1_score, accuracy_score
import numpy as np

router = APIRouter()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def _get_or_create_config(db: Session):
    """Ambil atau buat konfigurasi default"""
    config = db.query(KNNConfiguration).first()
    if not config:
        config = KNNConfiguration()
        db.add(config)
        db.commit()
        db.refresh(config)
    return config

def _calculate_model_metrics(db: Session, k_value: int):
    """Hitung akurasi dan metrics model berdasarkan K"""
    training_data = db.query(TrainingData).all()
    
    if len(training_data) < k_value:
        return {
            "accuracy": 0.0,
            "precision": 0.0,
            "recall": 0.0,
            "f1": 0.0
        }
    
    # Prepare data for KNN
    X = []
    y = []
    
    for training in training_data:
        nilai_list = db.query(TrainingNilai).filter_by(training_id=training.id).all()
        if nilai_list:
            features = [n.nilai for n in nilai_list]
            X.append(features)
            y.append(training.bidang_minat)
    
    if len(X) < k_value or len(X) < 2:
        return {
            "accuracy": 0.0,
            "precision": 0.0,
            "recall": 0.0,
            "f1": 0.0
        }
    
    try:
        # Normalize data
        scaler = MinMaxScaler()
        X_normalized = scaler.fit_transform(X)
        
        # Train KNN
        knn = KNeighborsClassifier(n_neighbors=k_value)
        knn.fit(X_normalized, y)
        
        # Predict
        y_pred = knn.predict(X_normalized)
        
        # Calculate metrics
        accuracy = accuracy_score(y, y_pred)
        
        # Handle multilabel classification
        if len(np.unique(y)) > 2:
            precision = precision_score(y, y_pred, average='weighted', zero_division=0)
            recall = recall_score(y, y_pred, average='weighted', zero_division=0)
            f1 = f1_score(y, y_pred, average='weighted', zero_division=0)
        else:
            precision = precision_score(y, y_pred, zero_division=0)
            recall = recall_score(y, y_pred, zero_division=0)
            f1 = f1_score(y, y_pred, zero_division=0)
        
        return {
            "accuracy": float(accuracy),
            "precision": float(precision),
            "recall": float(recall),
            "f1": float(f1)
        }
    except Exception as e:
        print(f"Error calculating metrics: {e}")
        return {
            "accuracy": 0.0,
            "precision": 0.0,
            "recall": 0.0,
            "f1": 0.0
        }

# ================= GET KNN CONFIGURATION =================
@router.get("/configuration", response_model=KNNConfigurationResponse)
def get_configuration(db: Session = Depends(get_db)):
    """Ambil konfigurasi KNN saat ini"""
    config = _get_or_create_config(db)
    return config

# ================= UPDATE KNN CONFIGURATION =================
@router.put("/configuration", response_model=KNNConfigurationResponse)
def update_configuration(req: KNNConfigurationRequest, db: Session = Depends(get_db)):
    """Update konfigurasi KNN dan hitung metrics"""
    config = _get_or_create_config(db)
    
    # Update configuration
    config.k_value = req.k_value
    config.algorithm = req.algorithm
    config.distance_metric = req.distance_metric
    config.normalization = req.normalization
    
    # Count training samples
    training_count = db.query(TrainingData).count()
    config.training_samples = training_count
    
    # Calculate metrics
    metrics = _calculate_model_metrics(db, req.k_value)
    config.model_accuracy = metrics["accuracy"] * 100  # Convert to percentage
    config.precision = metrics["precision"] * 100
    config.recall = metrics["recall"] * 100
    config.f1_score = metrics["f1"] * 100
    
    db.commit()
    db.refresh(config)
    
    return config

# ================= GET K VALUE ONLY =================
@router.get("/k")
def get_k(db: Session = Depends(get_db)):
    """Ambil nilai K saja"""
    config = _get_or_create_config(db)
    return {"k": config.k_value}

# ================= SET K VALUE =================
@router.post("/k")
def set_k(data: dict, db: Session = Depends(get_db)):
    """Update hanya nilai K"""
    config = _get_or_create_config(db)
    k_value = data.get("k", 3)
    
    config.k_value = k_value
    
    # Count training samples
    training_count = db.query(TrainingData).count()
    config.training_samples = training_count
    
    # Calculate metrics
    metrics = _calculate_model_metrics(db, k_value)
    config.model_accuracy = metrics["accuracy"] * 100
    config.precision = metrics["precision"] * 100
    config.recall = metrics["recall"] * 100
    config.f1_score = metrics["f1"] * 100
    
    db.commit()
    db.refresh(config)
    
    return {
        "message": "Nilai K berhasil diupdate",
        "k": config.k_value,
        "accuracy": config.model_accuracy
    }

# ================= GET METRICS =================
@router.get("/metrics")
def get_metrics(db: Session = Depends(get_db)):
    """Ambil metrics KNN"""
    config = _get_or_create_config(db)
    return {
        "training_samples": config.training_samples,
        "model_accuracy": config.model_accuracy,
        "precision": config.precision,
        "recall": config.recall,
        "f1_score": config.f1_score,
        "algorithm": config.algorithm,
        "distance_metric": config.distance_metric,
        "normalization": config.normalization
    }
