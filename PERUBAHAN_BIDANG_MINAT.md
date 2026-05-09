# 📋 Daftar Perubahan: Network & IoT → AI Engineering & Cyber Security

## 🎯 Ringkasan Perubahan
**Dari:** RPL, Jaringan (Network), IoT  
**Ke:** RPL, AI Engineering, Cyber Security

---

## 📁 FILE-FILE YANG PERLU DIUBAH

### 🔧 BACKEND (spk_backend/)

#### 1. **spk_backend/app/models.py**
- **Baris:** 31
- **Field:** `bidang_minat` dalam model `TrainingData`
- **Perubahan:** Tidak ada perubahan di model (field tetap ada), hanya data yang berubah
- **Status:** ✅ Tidak perlu diubah (kompatibel dengan string baru)

---

#### 2. **spk_backend/app/routers/training_router.py**
- **Baris 104-106:** Filter untuk statistik
  ```python
  # DARI:
  rpl = db.query(TrainingData).filter(TrainingData.bidang_minat == "RPL").count()
  jaringan = db.query(TrainingData).filter(TrainingData.bidang_minat == "Jaringan").count()
  iot = db.query(TrainingData).filter(TrainingData.bidang_minat == "IoT").count()
  
  # KE:
  rpl = db.query(TrainingData).filter(TrainingData.bidang_minat == "RPL").count()
  ai_engineering = db.query(TrainingData).filter(TrainingData.bidang_minat == "AI Engineering").count()
  cyber_security = db.query(TrainingData).filter(TrainingData.bidang_minat == "Cyber Security").count()
  ```

- **Baris 110-112:** Return dictionary
  ```python
  # DARI:
  return {
      "RPL": rpl,
      "Jaringan": jaringan,
      "IoT": iot
  }
  
  # KE:
  return {
      "RPL": rpl,
      "AI Engineering": ai_engineering,
      "Cyber Security": cyber_security
  }
  ```

- **Baris 125-128:** Inisialisasi yearly stats
  ```python
  # DARI:
  yearly_stats = {
      2022: {"RPL": 0, "Jaringan": 0, "IoT": 0},
      2023: {"RPL": 0, "Jaringan": 0, "IoT": 0},
      2024: {"RPL": 0, "Jaringan": 0, "IoT": 0},
      2025: {"RPL": 0, "Jaringan": 0, "IoT": 0},
  }
  
  # KE:
  yearly_stats = {
      2022: {"RPL": 0, "AI Engineering": 0, "Cyber Security": 0},
      2023: {"RPL": 0, "AI Engineering": 0, "Cyber Security": 0},
      2024: {"RPL": 0, "AI Engineering": 0, "Cyber Security": 0},
      2025: {"RPL": 0, "AI Engineering": 0, "Cyber Security": 0},
  }
  ```

- **Baris 141:** Default struktur yearly stats
  ```python
  # DARI:
  yearly_stats[year] = {"RPL": 0, "Jaringan": 0, "IoT": 0}
  
  # KE:
  yearly_stats[year] = {"RPL": 0, "AI Engineering": 0, "Cyber Security": 0}
  ```

---

#### 3. **spk_backend/app/routers/knn_settings_router.py**
- **Baris 52:** Penggunaan `bidang_minat` saat training
- **Perubahan:** Otomatis beradaptasi (tidak perlu hardcode)
- **Status:** ✅ Tidak perlu diubah (menggunakan data dari database)

---

#### 4. **spk_backend/app/routers/rekomendasi_router.py**
- **Baris 50:** Label dari training data
  ```python
  labels.append(t.bidang_minat)
  ```
- **Perubahan:** Otomatis beradaptasi (membaca dari database)
- **Status:** ✅ Tidak perlu diubah

---

#### 5. **spk_backend/app/routers/rekomendasi_router copy.py**
- **Baris 50:** Sama seperti rekomendasi_router.py
- **Status:** ✅ Tidak perlu diubah

---

### 📱 FRONTEND (rpl_yesss/)

#### 6. **rpl_yesss/lib/screens/admin/data_training_screen.dart**
- **Baris 24:** Inisialisasi variabel
  ```dart
  // DARI:
  String bidang = "RPL";
  
  // KE: (tetap sama)
  String bidang = "RPL";
  ```

- **Baris 73:** Dropdown options
  ```dart
  // DARI:
  items: ["RPL", "Jaringan", "IoT"]
      .map((e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ))
      .toList(),
  
  // KE:
  items: ["RPL", "AI Engineering", "Cyber Security"]
      .map((e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ))
      .toList(),
  ```

- **Baris 125-131:** Fungsi `getColor()`
  ```dart
  // DARI:
  Color getColor(String bidang) {
    switch (bidang) {
      case "RPL":
        return Colors.blue;
      case "Jaringan":
        return Colors.green;
      case "IoT":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
  
  // KE:
  Color getColor(String bidang) {
    switch (bidang) {
      case "RPL":
        return Colors.blue;
      case "AI Engineering":
        return Colors.orange; // atau warna lainnya
      case "Cyber Security":
        return Colors.red; // atau warna lainnya
      default:
        return Colors.grey;
    }
  }
  ```

---

#### 7. **rpl_yesss/lib/screens/admin/statistic_screen.dart**
- **Baris 18-20:** Deklarasi variabel
  ```dart
  // DARI:
  int total = 0;
  int rpl = 0;
  int jaringan = 0;
  int iot = 0;
  
  // KE:
  int total = 0;
  int rpl = 0;
  int ai_engineering = 0;
  int cyber_security = 0;
  ```

- **Baris 40:** Parsing data dari API
  ```dart
  // DARI:
  jaringan = stats["Jaringan"] ?? 0;
  iot = stats["IoT"] ?? 0;
  
  // KE:
  ai_engineering = stats["AI Engineering"] ?? 0;
  cyber_security = stats["Cyber Security"] ?? 0;
  ```

- **Baris 49:** Parsing yearly stats
  ```dart
  // DARI:
  "Jaringan": (value["Jaringan"] as num?)?.toInt() ?? 0,
  "IoT": (value["IoT"] as num?)?.toInt() ?? 0,
  
  // KE:
  "AI Engineering": (value["AI Engineering"] as num?)?.toInt() ?? 0,
  "Cyber Security": (value["Cyber Security"] as num?)?.toInt() ?? 0,
  ```

- **Baris 157:** Build bidang cards
  ```dart
  // DARI:
  _buildBidangCard("RPL", rpl.toString(), Colors.green),
  _buildBidangCard("Jaringan", jaringan.toString(), Colors.orange),
  _buildBidangCard("IoT", iot.toString(), Colors.purple),
  
  // KE:
  _buildBidangCard("RPL", rpl.toString(), Colors.green),
  _buildBidangCard("AI Engineering", ai_engineering.toString(), Colors.orange),
  _buildBidangCard("Cyber Security", cyber_security.toString(), Colors.red),
  ```

- **Baris 262:** Yearly stats parsing
  ```dart
  // DARI:
  int jaringanCount = yearlyStats[year]?["Jaringan"] ?? 0;
  int iotCount = yearlyStats[year]?["IoT"] ?? 0;
  
  // KE:
  int ai_engineeringCount = yearlyStats[year]?["AI Engineering"] ?? 0;
  int cyber_securityCount = yearlyStats[year]?["Cyber Security"] ?? 0;
  ```

- **Baris 264:** Max height calculation
  ```dart
  // DARI:
  int maxHeight = [rplCount, jaringanCount, iotCount]
  
  // KE:
  int maxHeight = [rplCount, ai_engineeringCount, cyber_securityCount]
  ```

- **Baris 287-290:** Chart bars (IoT Bar)
  ```dart
  // DARI:
  // IoT Bar (Grey)
  height: (iotCount / maxHeight * 160).toDouble(),
  
  // KE:
  // Cyber Security Bar (Red)
  height: (cyber_securityCount / maxHeight * 160).toDouble(),
  ```

---

## 📊 RINGKASAN FILE YANG DIUBAH

| File | Lokasi | Jumlah Perubahan | Tipe |
|------|--------|-----------------|------|
| training_router.py | Backend | 5 lokasi | Variabel & hardcode string |
| data_training_screen.dart | Frontend | 2 lokasi | Dropdown & fungsi warna |
| statistic_screen.dart | Frontend | 6 lokasi | Variabel & parsing data |
| **TOTAL** | - | **13 lokasi** | - |

---

## 🎨 SARAN WARNA (OPSIONAL)

### Skema Warna Original:
- **RPL:** Hijau (Colors.green)
- **Jaringan:** Oranye (Colors.orange)
- **IoT:** Ungu (Colors.purple)

### Saran Warna Baru:
- **RPL:** Biru (Colors.blue) ✓
- **AI Engineering:** Oranye/Kuning (Colors.orange / Colors.amber)
- **Cyber Security:** Merah (Colors.red / Colors.redAccent)

---

## ✅ CHECKLIST IMPLEMENTASI

### Backend Changes:
- [ ] Update `training_router.py` - get_statistics() function
- [ ] Update `training_router.py` - yearly_stats initialization
- [ ] Update `training_router.py` - get_yearly_statistics() function

### Frontend Changes:
- [ ] Update `data_training_screen.dart` - dropdown items
- [ ] Update `data_training_screen.dart` - getColor() switch case
- [ ] Update `statistic_screen.dart` - variable declarations
- [ ] Update `statistic_screen.dart` - API parsing (loadData)
- [ ] Update `statistic_screen.dart` - yearly stats parsing
- [ ] Update `statistic_screen.dart` - card building
- [ ] Update `statistic_screen.dart` - chart rendering

### Database:
- [ ] Update existing training data (ubah "Jaringan" → "AI Engineering", "IoT" → "Cyber Security")
- [ ] Atau clear database dan upload data baru

---

## 🚀 LANGKAH IMPLEMENTASI

1. **Backend:** Update string hardcode di training_router.py (3 lokasi)
2. **Frontend:** Update dropdown & fungsi warna di data_training_screen.dart (2 lokasi)
3. **Frontend:** Update statistic_screen.dart (6 lokasi)
4. **Database:** Migrasi data atau clear & re-upload
5. **Testing:** Test statistik, training data, dan rekomendasi

---

## 💾 DATABASE MIGRATION (Optional)

Jika ingin preserve data yang sudah ada:

```sql
-- PostgreSQL / MySQL
UPDATE training_data SET bidang_minat = 'AI Engineering' WHERE bidang_minat = 'Jaringan';
UPDATE training_data SET bidang_minat = 'Cyber Security' WHERE bidang_minat = 'IoT';
```

