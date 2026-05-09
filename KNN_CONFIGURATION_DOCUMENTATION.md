# 📊 KNN Configuration System - Dokumentasi Lengkap

## 🏗️ Arsitektur Integrasi Frontend-Backend-Database

### 1. DATABASE LAYER
Tabel baru: `knn_configuration`

```sql
CREATE TABLE knn_configuration (
    id INTEGER PRIMARY KEY,
    k_value INTEGER DEFAULT 3,
    algorithm VARCHAR(50) DEFAULT 'KNN',
    distance_metric VARCHAR(50) DEFAULT 'Euclidean Distance',
    normalization VARCHAR(50) DEFAULT 'Min-Max Scaling',
    training_samples INTEGER DEFAULT 0,
    model_accuracy FLOAT DEFAULT 0.0,
    precision FLOAT DEFAULT 0.0,
    recall FLOAT DEFAULT 0.0,
    f1_score FLOAT DEFAULT 0.0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
```

**Field Penjelasan:**
- `k_value`: Jumlah nearest neighbors (1-50)
- `algorithm`: Algoritma yang digunakan (KNN, K-Means, Decision Tree)
- `distance_metric`: Metrik jarak (Euclidean, Manhattan, Cosine)
- `normalization`: Teknik normalisasi data (Min-Max Scaling, Standard Scaler, None)
- `training_samples`: Jumlah sampel training di database
- `model_accuracy`: Akurasi model (%)
- `precision`: Precision score (%)
- `recall`: Recall score (%)
- `f1_score`: F1-Score (%)

---

### 2. BACKEND LAYER

#### 📁 File Modifikasi:

**a) `app/models.py`**
- ✅ Ditambahkan: `KNNConfiguration` model dengan SQLAlchemy ORM

**b) `app/schemas.py`**
- ✅ Ditambahkan: `KNNConfigurationRequest` (untuk input)
- ✅ Ditambahkan: `KNNConfigurationResponse` (untuk output)

**c) `app/routers/knn_settings_router.py` (FILE BARU)**
Endpoint REST API:

```
GET  /knn-settings/configuration
     → Ambil konfigurasi KNN saat ini

PUT  /knn-settings/configuration
     → Update konfigurasi dan hitung metrics
     Payload: {
         "k_value": 3,
         "algorithm": "KNN",
         "distance_metric": "Euclidean Distance",
         "normalization": "Min-Max Scaling"
     }

GET  /knn-settings/k
     → Ambil nilai K saja
     Response: { "k": 3 }

POST /knn-settings/k
     → Set nilai K dan hitung ulang metrics
     Payload: { "k": 3 }

GET  /knn-settings/metrics
     → Ambil metrics model (akurasi, precision, recall, f1-score)
```

#### 🔧 Cara Kerja Backend:

1. **Load Configuration:**
   - Saat user membuka halaman Set Nilai K, GET `/knn-settings/configuration` dipanggil
   - Jika belum ada, sistem membuat default configuration

2. **Calculate Metrics (Saat Save):**
   - Ambil semua training data dari database
   - Normalisasi data dengan MinMaxScaler
   - Train KNN model dengan k_value dari form
   - Hitung metrics: accuracy, precision, recall, f1-score
   - Simpan hasil ke database

3. **Update Configuration:**
   - Form data divalidasi
   - Metrics dihitung ulang berdasarkan k_value baru
   - Semua nilai disimpan ke tabel `knn_configuration`

---

### 3. FRONTEND LAYER

#### 📄 File Modifikasi:

**a) `lib/services/api_service.dart`**
- ✅ Ditambahkan: `getKNNConfiguration()` - GET /knn-settings/configuration
- ✅ Ditambahkan: `updateKNNConfiguration(config)` - PUT /knn-settings/configuration  
- ✅ Ditambahkan: `getKNNMetrics()` - GET /knn-settings/metrics

**b) `lib/screens/admin/set_k_screen.dart`**
- ✅ Redesign UI sesuai gambar kedua dengan:
  - Slider K Value (1-50)
  - Dropdown untuk Algorithm, Distance Metric, Normalization
  - Display Training Samples count
  - Progress bar Model Accuracy
  - Grid metrics: Precision, Recall, F1-Score, Accuracy
  - Save Configuration button

#### 🎨 UI Components:

1. **Configuration Card (Dark Theme)**
   ```
   ┌─────────────────────────────────┐
   │ K-Nearest Neighbor Configuration│
   │                                  │
   │ Nilai K Saat Ini        [  3   ]│
   │ [-] [======|====] [+] [input]   │
   │                                  │
   │ [algoritma] [Distance Metric]   │
   │ [Normalization] [Training: 10]  │
   │ Model Accuracy: 87.5%           │
   │ ████████░░░                      │
   └─────────────────────────────────┘
   ```

2. **Metrics Cards (Grid 2x2)**
   ```
   ┌──────────┬──────────┐
   │Precision │  Recall  │
   │    85    │    90    │
   │     %    │    %     │
   ├──────────┼──────────┤
   │ F1-Score │ Accuracy │
   │    87    │    88    │
   │     %    │    %     │
   └──────────┴──────────┘
   ```

3. **Save Configuration Button**
   ```
   [ save configuration ]
   ```

#### 📱 Cara Kerja Frontend:

1. **Initialization (initState)**
   - Panggil `getKNNConfiguration()` → ambil config dari backend
   - Panggil `getKNNMetrics()` → ambil metrics terbaru
   - Display di UI

2. **User Interaction**
   - User ubah K value melalui slider atau textfield
   - User pilih algorithm, distance metric, normalization
   - Perubahan otomatis di-update di state (real-time)

3. **Save Configuration**
   - Panggil `updateKNNConfiguration(config)` dengan data baru
   - Tunggu response dari backend (include metrics baru)
   - Update metrics di UI
   - Tampilkan snackbar success

---

## 🔄 Data Flow Diagram

```
┌─────────────────────────────────────────────────────┐
│              FRONTEND (Flutter)                      │
│                                                      │
│  SetKScreen                                         │
│  ├─ initState() → loadConfiguration()              │
│  │  ├─ GET /knn-settings/configuration ──┐         │
│  │  └─ GET /knn-settings/metrics ────────┤──────┐  │
│  │                                       │      │  │
│  └─ saveConfiguration()                  │      │  │
│     └─ PUT /knn-settings/configuration   │      │  │
│        ├─ Update k_value                 │      │  │
│        ├─ Update algorithm               │      │  │
│        ├─ Update distance_metric         │      │  │
│        └─ Update normalization           │      │  │
└────────────────────────┬──────────────────┼──────┼──┘
                         │                  │      │
                    HTTP │                  │      │
                    REST │                  │      │
                         │                  │      │
┌────────────────────────▼──────────────────▼──────▼──┐
│            BACKEND (FastAPI - Python)              │
│                                                     │
│  knn_settings_router.py                           │
│  ├─ GET /configuration                            │
│  │  └─ db.query(KNNConfiguration).first()        │
│  │                                                 │
│  ├─ PUT /configuration                            │
│  │  ├─ Update config fields                       │
│  │  ├─ Count training samples                     │
│  │  ├─ Calculate metrics:                         │
│  │  │  ├─ Load all training data                  │
│  │  │  ├─ Normalize with MinMaxScaler            │
│  │  │  ├─ Train KNeighborsClassifier             │
│  │  │  ├─ Predict & calculate metrics            │
│  │  │  └─ accuracy, precision, recall, f1       │
│  │  └─ db.commit()                                │
│  │                                                 │
│  └─ GET /metrics                                  │
│     └─ Return model_accuracy, precision, etc     │
└────────────────────────┬──────────────────────────┘
                         │
                    SQL  │
                   ORM   │
                         │
┌────────────────────────▼──────────────────────────┐
│           DATABASE (SQLite/MySQL)                 │
│                                                   │
│  knn_configuration                               │
│  ├─ id: 1                                        │
│  ├─ k_value: 3                                   │
│  ├─ algorithm: "KNN"                            │
│  ├─ distance_metric: "Euclidean Distance"       │
│  ├─ normalization: "Min-Max Scaling"            │
│  ├─ training_samples: 50                        │
│  ├─ model_accuracy: 87.5                        │
│  ├─ precision: 85.3                             │
│  ├─ recall: 90.1                                │
│  ├─ f1_score: 87.6                              │
│  └─ [timestamps]                                 │
│                                                   │
│  training_data (existing table)                 │
│  training_nilai (existing table)                │
└───────────────────────────────────────────────────┘
```

---

## 🚀 Setup & Testing Guide

### Backend Setup:
```bash
# 1. Install dependencies
pip install fastapi uvicorn sqlalchemy pydantic scikit-learn

# 2. Initialize KNN Configuration
python initialize_knn_config.py

# 3. Run backend
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Test API dengan cURL:
```bash
# Get configuration
curl http://localhost:8000/knn-settings/configuration

# Update configuration
curl -X PUT http://localhost:8000/knn-settings/configuration \
  -H "Content-Type: application/json" \
  -d '{
    "k_value": 5,
    "algorithm": "KNN",
    "distance_metric": "Euclidean Distance",
    "normalization": "Min-Max Scaling"
  }'

# Get metrics
curl http://localhost:8000/knn-settings/metrics
```

### Frontend Testing:
1. Jalankan Flutter app: `flutter run`
2. Login sebagai admin
3. Buka "Set Nilai K" dari sidebar
4. Ubah nilai K dengan slider
5. Pilih algorithm, distance metric, normalization
6. Klik "save configuration"
7. Lihat metrics terupdate secara real-time

---

## ⚙️ Configuration Default Values

| Parameter | Default | Range | Options |
|-----------|---------|-------|---------|
| K Value | 3 | 1-50 | Integer |
| Algorithm | KNN | - | KNN, K-Means, Decision Tree |
| Distance Metric | Euclidean Distance | - | Euclidean, Manhattan, Cosine |
| Normalization | Min-Max Scaling | - | Min-Max, Standard Scaler, None |
| Model Accuracy | 0.0 | 0-100 | % (calculated) |
| Precision | 0.0 | 0-100 | % (calculated) |
| Recall | 0.0 | 0-100 | % (calculated) |
| F1-Score | 0.0 | 0-100 | % (calculated) |

---

## 📊 Metrics Calculation Details

### Accuracy
```
Akurasi = (Jumlah Prediksi Benar) / (Total Sampel) × 100%
```
Menggunakan: `sklearn.metrics.accuracy_score(y_true, y_pred)`

### Precision
```
Precision = TP / (TP + FP)
```
Menggunakan: `sklearn.metrics.precision_score()` dengan `average='weighted'`

### Recall
```
Recall = TP / (TP + FN)
```
Menggunakan: `sklearn.metrics.recall_score()` dengan `average='weighted'`

### F1-Score
```
F1-Score = 2 × (Precision × Recall) / (Precision + Recall)
```
Menggunakan: `sklearn.metrics.f1_score()` dengan `average='weighted'`

---

## 🔒 Error Handling

### Frontend Errors:
- ✅ Connection timeout → Tampilkan snackbar
- ✅ Invalid K value (<=0) → Reject & show validation error
- ✅ API errors → Catch & display error message

### Backend Errors:
- ✅ Training samples < K value → Return 0.0 untuk semua metrics
- ✅ Database not found → Auto create dengan default values
- ✅ Calculation errors → Log & return 0.0

---

## 📝 Troubleshooting

**Problem:** Database table tidak ada
**Solution:** Jalankan backend, maka otomatis dibuat via `Base.metadata.create_all()`

**Problem:** Metrics menunjukkan 0%
**Solution:** Pastikan ada training data di database. Minimal: training_samples >= k_value

**Problem:** API returns 404
**Solution:** Pastikan router di-include di `app/main.py` dengan `app.include_router(knn_settings_router, prefix="/knn-settings")`

**Problem:** Flutter error "method not found"
**Solution:** Pastikan API service memiliki methods: `getKNNConfiguration()`, `updateKNNConfiguration()`, `getKNNMetrics()`

---

## 🎯 Next Steps

- [ ] Add unit tests untuk backend
- [ ] Add integration tests untuk frontend
- [ ] Add more algorithm options (K-Means, Decision Tree)
- [ ] Add data export/import functionality
- [ ] Add performance monitoring dashboard
- [ ] Add configuration history/audit trail

---

Generated: 2024
System: K-Nearest Neighbor SPK System
