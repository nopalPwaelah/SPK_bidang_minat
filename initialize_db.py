import sys
import os
sys.path.insert(0, os.path.dirname(__file__))

from pathlib import Path
import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy.orm import Session

# Import models and database
from app.database import SessionLocal, Base, engine
from app.models import TrainingData

def load_training_data():
    """Load training data from CSV to database"""
    
    # Ensure tables exist
    Base.metadata.create_all(bind=engine)
    
    # Path to dataset
    dataset_path = Path(__file__).parent / "datasets" / "dataset_mahasiswa_1000_numeric.csv"
    
    if not dataset_path.exists():
        print(f"Dataset not found at {dataset_path}")
        return False
    
    try:
        # Read CSV
        df = pd.read_csv(dataset_path)
        print(f"Loaded {len(df)} records from CSV")
        
        # Get database session
        db = SessionLocal()
        
        # Check if data already exists
        existing_count = db.query(TrainingData).count()
        if existing_count > 0:
            print(f"Database already has {existing_count} training records. Skipping...")
            db.close()
            return True
        
        # Column mapping from CSV to database
        column_mapping = {
            'Nama': 'nama',
            'Tahun': 'tahun_data',
            'Matematika': 'matematika',
            'Pemrograman Dasar': 'pemrograman_dasar',
            'Basis Data': 'basis_data',
            'Jaringan Komputer': 'jaringan_komputer',
            'Kecerdasan Buatan': 'kecerdasan_buatan',
            'Struktur Data': 'struktur_data',
            'Statistika': 'statistika',
            'Sistem Operasi': 'sistem_operasi',
            'Pemrograman Berorientasi Obyek': 'pbo',
            'Minat_Jurusan': 'minat_jurusan'
        }
        
        # Select and rename columns
        df_renamed = df.rename(columns=column_mapping)
        
        # Select only necessary columns
        cols_to_keep = [
            'nama', 'tahun_data', 'matematika', 'pemrograman_dasar',
            'basis_data', 'jaringan_komputer', 'kecerdasan_buatan',
            'struktur_data', 'statistika', 'sistem_operasi', 'pbo',
            'minat_jurusan'
        ]
        
        df_train = df_renamed[cols_to_keep].copy()
        
        # Ensure numeric columns are float
        numeric_cols = [
            'matematika', 'pemrograman_dasar', 'basis_data',
            'jaringan_komputer', 'kecerdasan_buatan', 'struktur_data',
            'statistika', 'sistem_operasi', 'pbo'
        ]
        
        for col in numeric_cols:
            df_train[col] = pd.to_numeric(df_train[col], errors='coerce')
        
        # Drop rows with NaN
        df_train = df_train.dropna()
        
        # Add records to database
        success_count = 0
        error_count = 0
        
        for idx, row in df_train.iterrows():
            try:
                training = TrainingData(
                    nama=row['nama'],
                    tahun_data=int(row['tahun_data']),
                    matematika=float(row['matematika']),
                    pemrograman_dasar=float(row['pemrograman_dasar']),
                    basis_data=float(row['basis_data']),
                    jaringan_komputer=float(row['jaringan_komputer']),
                    kecerdasan_buatan=float(row['kecerdasan_buatan']),
                    struktur_data=float(row['struktur_data']),
                    statistika=float(row['statistika']),
                    sistem_operasi=float(row['sistem_operasi']),
                    pbo=float(row['pbo']),
                    minat_jurusan=row['minat_jurusan']
                )
                db.add(training)
                success_count += 1
            except Exception as e:
                error_count += 1
                if error_count <= 5:  # Print first 5 errors
                    print(f"Error adding row {idx}: {e}")
        
        # Commit changes
        db.commit()
        db.close()
        
        print(f"Successfully added {success_count} records to database")
        if error_count > 0:
            print(f"Had {error_count} errors")
        
        return True
    
    except Exception as e:
        print(f"Error loading training data: {e}")
        import traceback
        traceback.print_exc()
        return False


if __name__ == "__main__":
    load_training_data()
