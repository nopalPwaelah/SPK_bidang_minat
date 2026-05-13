import pandas as pd
import os
from typing import List, Dict, Any
from pathlib import Path


# =========================================
# PATHS
# =========================================

DATASET_DIR = Path(__file__).parent.parent.parent / "datasets"
INPUT_USER_CSV = DATASET_DIR / "input_user.csv"
TRAINING_DATA_CSV = DATASET_DIR / "training_data.csv"
MAIN_DATASET = DATASET_DIR / "dataset_mahasiswa_1000_numeric.csv"


# =========================================
# ENSURE CSV FILES EXIST
# =========================================

def ensure_csv_files():
    """Buat file CSV jika belum ada"""
    
    # Create input user CSV if not exists
    if not INPUT_USER_CSV.exists():
        df = pd.DataFrame(columns=[
            'nama', 'tahun', 'ipk', 'pemrograman', 'basis_data',
            'cyber_security', 'ai', 'bidang_minat'
        ])
        df.to_csv(INPUT_USER_CSV, index=False)
    
    # Create training data CSV if not exists
    if not TRAINING_DATA_CSV.exists():
        load_initial_training_data()


# =========================================
# LOAD INITIAL TRAINING DATA
# =========================================

def load_initial_training_data():
    """Load data dari main dataset ke training_data.csv"""
    
    try:
        if not MAIN_DATASET.exists():
            print(f"Dataset tidak ditemukan di {MAIN_DATASET}")
            return False
        
        # Read main dataset
        df = pd.read_csv(MAIN_DATASET)
        
        # Map columns dari dataset ke training columns
        mapping = {
            'Nama': 'nama',
            'Matematika': 'matematika',
            'Pemrograman Dasar': 'pemrograman_dasar',
            'Basis Data': 'basis_data',
            'Jaringan Komputer': 'jaringan_komputer',
            'Kecerdasan Buatan': 'kecerdasan_buatan',
            'Struktur Data': 'struktur_data',
            'Statistika': 'statistika',
            'Sistem Operasi': 'sistem_operasi',
            'Pemrograman Berorientasi Obyek': 'pbo',
            'Minat_Jurusan': 'minat_jurusan',
            'Tahun': 'tahun_data'
        }
        
        # Select dan rename columns
        selected_cols = {
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
        
        # Rename columns
        df_renamed = df.rename(columns=selected_cols)
        
        # Select only necessary columns
        df_training = df_renamed[[
            'nama', 'tahun_data', 'matematika', 'pemrograman_dasar',
            'basis_data', 'jaringan_komputer', 'kecerdasan_buatan',
            'struktur_data', 'statistika', 'sistem_operasi', 'pbo',
            'minat_jurusan'
        ]]
        
        # Ensure all numeric columns are float
        numeric_cols = [
            'matematika', 'pemrograman_dasar', 'basis_data',
            'jaringan_komputer', 'kecerdasan_buatan', 'struktur_data',
            'statistika', 'sistem_operasi', 'pbo'
        ]
        
        for col in numeric_cols:
            df_training[col] = pd.to_numeric(
                df_training[col],
                errors='coerce'
            )
        
        # Drop rows with NaN values
        df_training = df_training.dropna()
        
        # Save to training data CSV
        df_training.to_csv(TRAINING_DATA_CSV, index=False)
        print(f"Training data loaded: {len(df_training)} records")
        return True
    
    except Exception as e:
        print(f"Error loading initial training data: {e}")
        return False


# =========================================
# GET TRAINING DATA
# =========================================

def get_training_data() -> List[Dict[str, Any]]:
    """Ambil semua training data"""
    
    try:
        ensure_csv_files()
        
        if not TRAINING_DATA_CSV.exists():
            return []
        
        df = pd.read_csv(TRAINING_DATA_CSV)
        
        # Convert to list of dicts
        data = df.to_dict('records')
        
        return data
    
    except Exception as e:
        print(f"Error getting training data: {e}")
        return []


# =========================================
# ADD INPUT USER
# =========================================

def add_input_user(data: Dict[str, Any]) -> bool:
    """Tambah data input user baru"""
    
    try:
        ensure_csv_files()
        
        # Validasi data
        if not all(k in data for k in ['nama', 'tahun', 'ipk', 'pemrograman', 
                                        'basis_data', 'cyber_security', 'ai', 'bidang_minat']):
            print("Data tidak lengkap")
            return False
        
        # Read existing data
        df = pd.read_csv(INPUT_USER_CSV) if INPUT_USER_CSV.exists() else pd.DataFrame()
        
        # Create new row
        new_row = pd.DataFrame([data])
        
        # Append
        df = pd.concat([df, new_row], ignore_index=True)
        
        # Save
        df.to_csv(INPUT_USER_CSV, index=False)
        print(f"Added input user: {data['nama']}")
        return True
    
    except Exception as e:
        print(f"Error adding input user: {e}")
        return False


# =========================================
# GET INPUT USERS
# =========================================

def get_input_users() -> List[Dict[str, Any]]:
    """Ambil semua input user"""
    
    try:
        ensure_csv_files()
        
        if not INPUT_USER_CSV.exists():
            return []
        
        df = pd.read_csv(INPUT_USER_CSV)
        
        if df.empty:
            return []
        
        data = df.to_dict('records')
        return data
    
    except Exception as e:
        print(f"Error getting input users: {e}")
        return []


# =========================================
# DELETE INPUT USER
# =========================================

def delete_input_user(index: int) -> bool:
    """Hapus input user berdasarkan index"""
    
    try:
        ensure_csv_files()
        
        if not INPUT_USER_CSV.exists():
            return False
        
        df = pd.read_csv(INPUT_USER_CSV)
        
        if index >= len(df):
            return False
        
        # Drop row
        df = df.drop(index).reset_index(drop=True)
        
        # Save
        df.to_csv(INPUT_USER_CSV, index=False)
        print(f"Deleted input user at index {index}")
        return True
    
    except Exception as e:
        print(f"Error deleting input user: {e}")
        return False


# =========================================
# PROCESS TRAINING
# =========================================

def process_training() -> bool:
    """Pindahkan data dari input user ke training data"""
    
    try:
        ensure_csv_files()
        
        # Get input users
        input_users = get_input_users()
        
        if not input_users:
            print("Tidak ada data input user untuk di-train")
            return False
        
        # Read existing training data
        if TRAINING_DATA_CSV.exists():
            df_training = pd.read_csv(TRAINING_DATA_CSV)
        else:
            df_training = pd.DataFrame()
        
        # Convert input users to training format
        df_input = pd.DataFrame(input_users)
        
        # Rename columns
        column_mapping = {
            'pemrograman': 'pemrograman_dasar',
            'cyber_security': 'jaringan_komputer',  # Map cyber security to jaringan
            'ai': 'kecerdasan_buatan',
            'bidang_minat': 'minat_jurusan'
        }
        
        df_input = df_input.rename(columns=column_mapping)
        
        # Add default values for missing columns
        if 'struktur_data' not in df_input.columns:
            df_input['struktur_data'] = 0.0
        if 'sistem_operasi' not in df_input.columns:
            df_input['sistem_operasi'] = 0.0
        if 'pbo' not in df_input.columns:
            df_input['pbo'] = 0.0
        if 'jaringan_komputer' not in df_input.columns:
            df_input['jaringan_komputer'] = 0.0
        if 'tahun_data' not in df_input.columns:
            df_input['tahun_data'] = 2024
        
        # Ensure numeric types
        numeric_cols = [
            'ipk', 'pemrograman_dasar', 'basis_data',
            'jaringan_komputer', 'kecerdasan_buatan', 'struktur_data',
            'statistika', 'sistem_operasi', 'pbo'
        ]
        
        for col in numeric_cols:
            if col in df_input.columns:
                df_input[col] = pd.to_numeric(df_input[col], errors='coerce')
        
        # Select columns in correct order
        cols = [
            'nama', 'tahun_data', 'matematika', 'pemrograman_dasar',
            'basis_data', 'jaringan_komputer', 'kecerdasan_buatan',
            'struktur_data', 'statistika', 'sistem_operasi', 'pbo',
            'minat_jurusan'
        ]
        
        # Check if all columns exist
        for col in cols:
            if col not in df_input.columns:
                print(f"Column {col} not found in input data")
                return False
        
        df_input = df_input[cols]
        
        # Drop NaN values
        df_input = df_input.dropna()
        
        # Append to training data
        df_training = pd.concat([df_training, df_input], ignore_index=True)
        
        # Save
        df_training.to_csv(TRAINING_DATA_CSV, index=False)
        
        # Clear input user CSV
        pd.DataFrame(columns=[
            'nama', 'tahun', 'ipk', 'pemrograman', 'basis_data',
            'cyber_security', 'ai', 'bidang_minat'
        ]).to_csv(INPUT_USER_CSV, index=False)
        
        print(f"Training process complete: {len(df_input)} records added")
        return True
    
    except Exception as e:
        print(f"Error in process_training: {e}")
        return False


# =========================================
# INIT
# =========================================

# Initialize CSV files on import
ensure_csv_files()
