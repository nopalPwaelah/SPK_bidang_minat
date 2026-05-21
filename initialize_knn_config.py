"""
Script untuk initialize KNN Configuration database
"""
import sys
sys.path.insert(0, '/e/SPK_bidang_minat/spk_backend')

from app.database import SessionLocal
from app.models import KNNConfiguration

def initialize_knn_config():
    db = SessionLocal()
    try:
        # Check if config exists
        existing = db.query(KNNConfiguration).first()
        if existing:
            print("KNN Configuration already exists")
            return
        
        # Create default configuration
        default_config = KNNConfiguration(
            k_value=3,
            algorithm="KNN",
            distance_metric="Euclidean Distance",
            normalization="Min-Max Scaling",
            training_samples=0,
            model_accuracy=0.0,
            precision=0.0,
            recall=0.0,
            f1_score=0.0
        )
        
        db.add(default_config)
        db.commit()
        print("✅ KNN Configuration initialized successfully")
        
    except Exception as e:
        print(f"❌ Error initializing KNN Configuration: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    initialize_knn_config()
