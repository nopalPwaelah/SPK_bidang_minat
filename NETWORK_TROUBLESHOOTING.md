# Network & Connectivity Troubleshooting

## Masalah yang Ditemukan

### 1. **Error: "Tidak bisa konek ke server: ClientException: Failed to fetch"**

**Lokasi:** Admin Dashboard → Fetch Mahasiswa Baru

**Root Cause:** Flutter Web app di Vercel tidak bisa connect ke Railway backend dengan konsisten.

**Backend Status:** ✅ Berfungsi Normal
- Response time: 542ms
- Endpoint: `https://spkbidangminat-production.up.railway.app/training/`
- Data: 1000 training records tersedia
- Statistics: ✅ Available
- Users: ✅ Available

**Penyebab:**
- Network latency antara Vercel (Flutter Web) dan Railway (Backend)
- Timeout setting terlalu kecil (15 detik → 30 detik sekarang)
- Retry mechanism yang tidak ada

---

## Perbaikan yang Sudah Dilakukan

### 1. **Increased Timeout & Added Retry Logic**
**File:** `rpl_yesss/lib/services/api_service.dart`

```dart
// Before: 15 second timeout, 1 attempt
// After: 30 second timeout, 3 retry attempts with exponential backoff
```

**Changes:**
- Timeout diperpanjang: 15s → 30s
- Added retry mechanism: max 3 attempts
- Exponential backoff: 1s, 2s, 3s delay between retries
- Better error messages with retry count

### 2. **Improved Error Handling**
**Files:**
- `rpl_yesss/lib/screens/admin/data_training_screen.dart`
- `rpl_yesss/lib/screens/admin/statistic_screen.dart`

**Changes:**
- Added SnackBar error messages
- Better exception displaying
- Mounted state checking before setState

---

## API Endpoints Status

| Endpoint | Status | Response Time | Data |
|----------|--------|---------------|----|
| `/training/` | ✅ 200 OK | 542ms | 1000 records |
| `/training/stats/summary` | ✅ 200 OK | Fast | Total: 1000, RPL: 351, AI: 323, CS: 326 |
| `/training/stats/yearly` | ✅ 200 OK | Fast | 2022-2026 yearly breakdown |
| `/users/` | ✅ 200 OK | Fast | Admin: 1, User: 1 |
| `/auth/login` | ✅ 200 OK | Fast | Login functional |

---

## Debugging Steps

### 1. **Check Network Tab (Browser DevTools)**
- Open DevTools → Network tab
- Refresh page
- Look for failed requests to `spkbidangminat-production.up.railway.app`
- Check response headers for CORS issues

### 2. **Monitor Console Errors**
- Open DevTools → Console tab
- Look for network errors or timeout exceptions
- Retry mechanism should automatically retry 3 times

### 3. **Check API Response**
```bash
# Test endpoint directly
curl https://spkbidangminat-production.up.railway.app/training/

# Should return 1000 records in JSON format
```

---

## Recommended Actions

### For Production Deployment:

1. **Consider Alternative Backend URL**
   - Railway might be experiencing cold starts
   - Add health check endpoint monitoring

2. **Increase Timeouts Further**
   - Current: 30s per request (with 3 retries = 90s max)
   - Consider 45s if Railway has slow startup

3. **Implement Circuit Breaker**
   - Add fallback UI when backend unreachable
   - Cache data locally if possible

4. **Monitor Vercel Logs**
   - Check Vercel deployment logs for network issues
   - Check Railway deployment logs for performance issues

5. **Consider CDN Optimization**
   - Both Vercel (frontend) and Railway (backend) should be in same region
   - Check region configuration in both platforms

---

## Bug Fixes Applied

### Bug #1: Role Mapping Reversed in Backend ✅ FIXED

**File:** `spk_backend/app/routers/user_router.py`

**Issue:**
```python
# BEFORE (WRONG)
def _role_name(role_id: int) -> str:
    if role_id == 2:
        return "admin"      # ❌ role_id 2 should be mahasiswa
    return "mahasiswa"

# AFTER (CORRECT)
def _role_name(role_id: int) -> str:
    if role_id == 1:
        return "admin"      # ✅ role_id 1 = admin
    return "mahasiswa"      # role_id 2 = mahasiswa
```

**Impact:**
- Admin dashboard could not filter users correctly
- Create user endpoint had inverted role logic

---

## Next Steps

1. **Redeploy Backend** after role mapping fix
2. **Test with Network DevTools** to capture actual network behavior
3. **Monitor error rates** after retry mechanism deployment
4. **Collect metrics** on success rates with new timeout/retry settings
5. **Consider Redis caching** for frequently accessed data (statistics, training list)
