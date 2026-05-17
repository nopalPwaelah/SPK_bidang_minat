# Panduan Integrasi SPK KNN - Complete Integration Guide

## 📋 Ringkasan Integrasi

Sistem SPK KNN telah diintegrasikan dengan alur kerja lengkap:
1. **Database XAMPP** terhubung untuk user registration/login
2. **Input nilai user** → disimpan ke database
3. **KNN processing otomatis** setelah input nilai
4. **Hasil prediksi** ditampilkan ke user
5. **Admin dapat mengatur K value** untuk KNN

---

## 🔄 Alur Sistem Lengkap

### 1. **USER REGISTRATION & LOGIN**
```
Flutter Login Screen
    ↓
POST /auth/login (email, password)
    ↓
MySQL XAMPP (users table)
    ↓
Token + Role (1=Admin, 2=User)
    ↓
Navigate ke Dashboard
```

**Lokasi File:**
- Flutter: [rpl_yesss/lib/screens/auth/login_screen.dart](rpl_yesss/lib/screens/auth/login_screen.dart)
- Backend: [spk_backend/app/routers/auth_router.py](spk_backend/app/routers/auth_router.py)

---

### 2. **USER INPUT NILAI**
```
User Dashboard
    ↓
InputNilaiScreen (user input 10 kriteria nilai)
    ↓
Click "ANALYZE"
    ↓
POST /rekomendasi/predict
    (nama, matematika, pemrograman_dasar, basis_data, 
     jaringan_komputer, kecerdasan_buatan, struktur_data, 
     statistika, sistem_operasi, pbo)
```

**Lokasi File:**
- Flutter: [rpl_yesss/lib/screens/users/input_nilai_screen.dart](rpl_yesss/lib/screens/users/input_nilai_screen.dart)
- API Call: `ApiService.submitNilai(Map<String, dynamic> data)`

---

### 3. **KNN PROCESSING OTOMATIS**
```
Backend /rekomendasi/predict endpoint:

1. Ambil training data dari database
2. Buat DataFrame dari training data
3. Normalisasi semua nilai (MinMax Scaling)
4. Ambil nilai K dari database (default 3)
5. Train KNeighborsClassifier dengan X, y
6. Input user di-convert dengan convert_nilai()
7. Predict menggunakan model
8. Simpan hasil ke prediction_result table
9. Return hasil prediksi ke Flutter
```

**Lokasi File:**
- Backend: [spk_backend/app/routers/rekomendasi_router.py](spk_backend/app/routers/rekomendasi_router.py)
- KNN Service: [spk_backend/app/services/knn_service.py](spk_backend/app/services/knn_service.py)
- Nilai Converter: [spk_backend/app/services/nilai_converter.py](spk_backend/app/services/nilai_converter.py)

---

### 4. **TAMPILKAN HASIL**
```
Backend return:
{
    "nama": "John Doe",
    "hasil_prediksi": "AI Engineering",
    "nilai_k": 3
}
    ↓
HasilScreen menampilkan:
- Bidang Minat Rekomendasi
- Detail Nama & K Value
- Grid nilai input user
- Tombol Simpan & Kembali
```

**Lokasi File:**
- Flutter: [rpl_yesss/lib/screens/users/hasil_screen.dart](rpl_yesss/lib/screens/users/hasil_screen.dart) (SUDAH DIUPDATE)

---

### 5. **ADMIN SETTING K VALUE**
```
Admin Login (role = 1)
    ↓
Admin Dashboard
    ↓
SetKScreen
    ↓
Ubah K Value (default 3)
    ↓
PUT /knn-settings/k
    ({"nilai_k": 5})
    ↓
Backend calculate metrics:
- Accuracy
- Precision
- Recall
- F1 Score
    ↓
Update KNNConfiguration table
```

**Lokasi File:**
- Flutter: [rpl_yesss/lib/screens/admin/set_k_screen.dart](rpl_yesss/lib/screens/admin/set_k_screen.dart)
- Backend: [spk_backend/app/routers/knn_settings_router.py](spk_backend/app/routers/knn_settings_router.py)

---

## 🗄️ Database Schema (XAMPP - spk_knn)

### Tables yang Digunakan:

#### 1. **users** (untuk auth)
```
id (PK)
username
email (unique)
password (hashed)
role_id (1=Admin, 2=User)
```

#### 2. **training_data** (data latih KNN)
```
id (PK)
nama
matematika
pemrograman_dasar
basis_data
jaringan_komputer
kecerdasan_buatan
struktur_data
statistika
sistem_operasi
pbo
minat_jurusan (target: "AI Engineering", "Cyber Security", "RPL")
tahun_data
created_at
```

#### 3. **prediction_result** (hasil prediksi user)
```
id (PK)
nama
matematika ... pbo (nilai input)
hasil_prediksi (hasil KNN)
nilai_k
created_at
```

#### 4. **knn_configuration** (setting KNN)
```
id (PK)
k_value (default 3)
algorithm ("KNN")
distance_metric ("Euclidean Distance")
normalization ("Min-Max Scaling")
training_samples
model_accuracy
precision
recall
f1_score
updated_at
```

---

## 🚀 Cara Menjalankan Sistem

### Backend (Python FastAPI)

1. **Setup Database:**
```bash
# Buka XAMPP Control Panel
# Start MySQL
# Buat database: spk_knn
```

2. **Install Dependencies:**
```bash
cd spk_backend
pip install -r requirements.txt
```

3. **Jalankan Backend:**
```bash
cd spk_backend
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Frontend (Flutter)

1. **Pastikan Backend Berjalan di http://127.0.0.1:8000**

2. **Jalankan Flutter:**
```bash
cd rpl_yesss
flutter pub get
flutter run
# Pilih device (HP/Emulator)
```

3. **API Config:**
```dart
// Di lib/core/config/api_config.dart
static const String baseUrl = "http://127.0.0.1:8000";
// Untuk emulator Android: "http://10.0.2.2:8000"
```

---

## 📝 API Endpoints Lengkap

### Authentication
```
POST /auth/register
POST /auth/login
```

### KNN Prediction
```
POST /rekomendasi/predict
GET /rekomendasi/history
DELETE /rekomendasi/history/{history_id}
GET /rekomendasi/history/summary
```

### KNN Settings
```
GET /knn-settings/k
PUT /knn-settings/k
GET /knn-settings/configuration
PUT /knn-settings/configuration
GET /knn-settings/metrics
```

### Training Data
```
GET /training
POST /training
PUT /training/{id}
DELETE /training/{id}
```

### User Input
```
POST /user-input/
GET /user-input/
POST /user-input/train
```

---

## 🔍 Testing API dengan Postman/Curl

### 1. Register User
```bash
curl -X POST http://127.0.0.1:8000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "email": "john@example.com",
    "password": "password123"
  }'
```

### 2. Login
```bash
curl -X POST http://127.0.0.1:8000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

### 3. Predict KNN
```bash
curl -X POST http://127.0.0.1:8000/rekomendasi/predict \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer {TOKEN}" \
  -d '{
    "nama": "Naufal Akbar",
    "matematika": 3.5,
    "pemrograman_dasar": 3.8,
    "basis_data": 3.6,
    "jaringan_komputer": 3.2,
    "kecerdasan_buatan": 3.9,
    "struktur_data": 3.7,
    "statistika": 3.4,
    "sistem_operasi": 3.5,
    "pbo": 3.8
  }'
```

### 4. Set K Value
```bash
curl -X PUT http://127.0.0.1:8000/knn-settings/k \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer {TOKEN}" \
  -d '{"nilai_k": 5}'
```

---

## ✅ Checklist Implementasi

- [x] Database XAMPP dikonfigurasi
- [x] Tables sudah dibuat (users, training_data, prediction_result, knn_configuration)
- [x] Backend API semua endpoints berjalan
- [x] Flutter screens terhubung ke API
- [x] Login/Register terhubung database
- [x] Input nilai screen terhubung ke prediction endpoint
- [x] Hasil screen menampilkan prediksi dengan UI yang baik
- [x] Admin K setting screen terhubung ke knn-settings endpoint
- [x] KNN otomatis memproses setelah user input nilai
- [ ] Testing end-to-end sistem

---

## 🐛 Troubleshooting

### Error: "Tidak bisa konek ke server"
→ Pastikan backend running di port 8000
→ Check API baseUrl di `api_config.dart`

### Error: "Database connection failed"
→ Pastikan XAMPP MySQL sudah running
→ Cek database URL di `database.py`:
```python
DATABASE_URL = "mysql+pymysql://root:@localhost:3306/spk_knn"
```

### Error: "Training data kosong"
→ Pastikan ada data di `training_data` table
→ Tambahkan sample data melalui `/training` POST endpoint

### Error: "User sudah terdaftar"
→ Gunakan email yang berbeda untuk register baru

---

## 📚 File-File Penting

**Frontend:**
- `lib/services/api_service.dart` - Semua API calls
- `lib/screens/auth/login_screen.dart` - Login
- `lib/screens/users/input_nilai_screen.dart` - Input nilai
- `lib/screens/users/hasil_screen.dart` - Tampil hasil
- `lib/screens/admin/set_k_screen.dart` - Setting K

**Backend:**
- `app/main.py` - Entry point & router setup
- `app/routers/auth_router.py` - Authentication
- `app/routers/rekomendasi_router.py` - KNN Prediction
- `app/routers/knn_settings_router.py` - KNN Configuration
- `app/models.py` - Database models
- `app/schemas.py` - Pydantic schemas

---

## 📞 Dukungan

Untuk pertanyaan atau masalah:
1. Cek logs di terminal backend
2. Cek Flutter console output
3. Gunakan Postman untuk test API endpoints
4. Verifikasi database connection

---

**Last Updated:** 17 Mei 2026
**Status:** ✅ Integrasi Lengkap - Ready for Testing
