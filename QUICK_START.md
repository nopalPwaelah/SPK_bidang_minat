# 🚀 QUICK START GUIDE - KNN Configuration System

## ⚡ 5 MENIT SETUP

### Terminal 1: Initialize Database
```bash
cd e:\SPK_bidang_minat\spk_backend

# Install scikit-learn jika belum
pip install scikit-learn

# Initialize KNN config ke database
python initialize_knn_config.py

# Expected output:
# ✅ KNN Configuration initialized successfully
```

### Terminal 2: Jalankan Backend
```bash
cd e:\SPK_bidang_minat\spk_backend

# Run server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Expected output:
# INFO:     Uvicorn running on http://0.0.0.0:8000
```

### Terminal 3: Jalankan Frontend
```bash
cd e:\SPK_bidang_minat\rpl_yesss

# Run app
flutter run

# App akan membuka di emulator/device
```

---

## 🎯 TEST FITUR

### 1. Login
- Email: `admin@example.com` (or your admin account)
- Password: (your password)

### 2. Navigasi ke Set Nilai K
- Buka sidebar (hamburger menu)
- Click "Set Nilai K"

### 3. Lihat Configuration
- UI menampilkan:
  - K Value slider (currently: 3)
  - Algorithm: KNN
  - Distance Metric: Euclidean Distance
  - Normalization: Min-Max Scaling
  - Training Samples count
  - Model Accuracy percentage
  - Metrics cards

### 4. Test Slider
- Drag slider K value dari 1 hingga 50
- Lihat update real-time

### 5. Test Save
- Ubah K value ke 5 (atau nilai lain)
- Ubah algorithm ke K-Means (optional)
- Click "save configuration"
- Tunggu 2-3 detik (backend calculate metrics)
- Lihat snackbar: "Konfigurasi berhasil disimpan"
- Lihat metrics terupdate

---

## 📍 FILE PENTING

```
e:\SPK_bidang_minat\
├── spk_backend\
│   ├── app\
│   │   ├── models.py ⭐ (KNNConfiguration model)
│   │   ├── schemas.py ⭐ (request/response schemas)
│   │   ├── main.py ⭐ (include router)
│   │   └── routers\
│   │       ├── knn_settings_router.py ⭐ (NEW - REST API)
│   │       └── __init__.py ⭐ (updated)
│   └── initialize_knn_config.py ⭐ (NEW - init script)
│
├── rpl_yesss\
│   └── lib\
│       ├── services\
│       │   └── api_service.dart ⭐ (added methods)
│       └── screens\
│           └── admin\
│               └── set_k_screen.dart ⭐ (REDESIGNED)
│
├── KNN_CONFIGURATION_DOCUMENTATION.md ⭐ (LENGKAP!)
├── CHANGES_SUMMARY.md ⭐ (RINGKASAN)
└── FILE_CHANGES_CHECKLIST.md ⭐ (CHECKLIST)
```

⭐ = File penting yang berubah/baru

---

## 🔍 TROUBLESHOOTING CEPAT

### ❌ Error: "No module named 'sklearn'"
```bash
pip install scikit-learn
```

### ❌ Error: "Connection refused"
- Pastikan backend sudah running di port 8000
- Check terminal 2 ada "Uvicorn running" message

### ❌ Error: "Database table not found"
- Backend otomatis create table saat startup
- Tunggu backend fully loaded

### ❌ Metrics menunjukkan 0%
- Tambah beberapa training data dulu
- Minimal 3+ training samples

### ❌ Slider tidak bergerak
- Reload app: Hot Reload (R) atau Restart (Shift+R)

---

## 📊 SAMPLE DATA TESTING

Jika ingin test dengan data, masukkan beberapa training data:

```
Go ke: Admin Dashboard → Data Training
Tambah sample:
1. Nama: Student 1, IPK: 3.5, Bidang: RPL
2. Nama: Student 2, IPK: 3.2, Bidang: RPL
3. Nama: Student 3, IPK: 3.0, Bidang: BD
... (lebih banyak lebih bagus)
```

Kemudian test Set Nilai K → metrics akan dihitung

---

## ✅ SUCCESS INDICATORS

Jika berhasil, kamu akan lihat:

1. ✅ Page "K-Nearest Neighbor Configuration" tampil
2. ✅ K value slider bisa digeser (1-50)
3. ✅ Semua dropdown bisa dipilih
4. ✅ Training Samples count terupdate
5. ✅ Model Accuracy menunjukkan percentage
6. ✅ Metrics card menampilkan 4 nilai (Precision, Recall, F1, Accuracy)
7. ✅ Click save → snackbar success
8. ✅ Metrics terupdate setelah save
9. ✅ Accuracy bar berwarna (hijau/amber/merah)
10. ✅ Tidak ada error di debug console

---

## 🎨 UI PREVIEW

```
┌─────────────────────────────────────────────┐
│ K-Nearest Neighbor Configuration            │ (AppBar)
│                                              │
│ ╔─────────────────────────────────────────╗ │ (Dark Card)
│ │ Nilai K Saat Ini              [  5   ]  │ │
│ │ [-] [═════|═════] [+] [50]              │ │
│ │                                         │ │
│ │ [KNN] [Euclidean Distance]             │ │
│ │ [Min-Max Scaling] [Training: 50]       │ │
│ │                                         │ │
│ │ Model Accuracy:  87.5%                 │ │
│ │ ████████████░░░░░░░░░                 │ │
│ ╚─────────────────────────────────────────╝ │
│                                              │
│ Model Metrics                               │
│ ┌────────────────┬────────────────┐        │ (Metrics Grid)
│ │ Precision      │ Recall         │        │
│ │      85        │      90        │        │
│ │       %        │       %        │        │
│ ├────────────────┼────────────────┤        │
│ │ F1-Score       │ Accuracy       │        │
│ │      87        │      88        │        │
│ │       %        │       %        │        │
│ └────────────────┴────────────────┘        │
│                                              │
│ [ save configuration ]                      │ (Button)
│                                              │
└─────────────────────────────────────────────┘
```

---

## 📚 DOKUMENTASI LENGKAP

Untuk detail lebih lanjut, baca:

1. **KNN_CONFIGURATION_DOCUMENTATION.md**
   - Arsitektur lengkap
   - Database schema detail
   - Endpoint documentation
   - Data flow diagrams
   - Troubleshooting guide

2. **CHANGES_SUMMARY.md**
   - List semua perubahan
   - Before/after UI
   - Testing commands
   - Requirements detail

3. **FILE_CHANGES_CHECKLIST.md**
   - Checklist lengkap
   - Verifikasi status
   - Dependencies list

---

## 🔗 API ENDPOINTS SUMMARY

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/knn-settings/configuration` | Ambil config |
| PUT | `/knn-settings/configuration` | Update config & metrics |
| GET | `/knn-settings/k` | Ambil K value |
| POST | `/knn-settings/k` | Set K value |
| GET | `/knn-settings/metrics` | Ambil metrics |

---

## 💾 DATABASE SCHEMA

```sql
knn_configuration {
  id: int (primary key)
  k_value: int
  algorithm: string
  distance_metric: string
  normalization: string
  training_samples: int
  model_accuracy: float
  precision: float
  recall: float
  f1_score: float
  created_at: timestamp
  updated_at: timestamp
}
```

---

## 🎯 NEXT STEPS (OPTIONAL)

- [ ] Add unit tests
- [ ] Add more algorithms
- [ ] Add configuration history
- [ ] Add performance graphs
- [ ] Add data export feature
- [ ] Add real-time monitoring

---

## 📞 SUPPORT

Jika ada error:

1. Check error message di debug console
2. Baca troubleshooting section di atas
3. Check API response dengan curl command
4. Review documentation files

---

**Status:** ✅ READY TO USE
**Version:** 1.0
**Last Updated:** 2024

Selamat menggunakan! 🎉
