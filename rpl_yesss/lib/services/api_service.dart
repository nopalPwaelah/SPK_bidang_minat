import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/api_config.dart';

class ApiService {
  static String get baseUrl => ApiConfig.baseUrl;

  static String? token;

  // ================= HEADER =================
  static Map<String, String> get headers => {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

  // ================= HELPER =================
  static dynamic handleResponse(http.Response res) {
    print("URL: ${res.request?.url}");
    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

    final data = jsonDecode(res.body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return data;
    } else {
      throw Exception(data["detail"] ?? "Server error");
    }
  }

  static Future<http.Response> safeRequest(
      Future<http.Response> request) async {
    try {
      return await request.timeout(const Duration(seconds: 15));
    } catch (e) {
      throw Exception("Tidak bisa konek ke server: $e");
    }
  }

  // ================= LOGIN =================
  static Future login(String email, String password) async {
    final res = await safeRequest(
      http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      ),
    );

    final data = handleResponse(res);

    if (data["access_token"] != null) {
      token = data["access_token"];
    }

    return data;
  }

  // ================= REGISTER =================
  static Future register(
      String username, String email, String password) async {
    final res = await safeRequest(
      http.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }),
      ),
    );

    return handleResponse(res);
  }

  // ================= USERS =================
  static Future<List> getUsers() async {
    final res = await safeRequest(
      http.get(Uri.parse("$baseUrl/users"), headers: headers),
    );

    return handleResponse(res);
  }

  static Future addUser(
      String username, String email, String password, String role) async {
    final res = await safeRequest(
      http.post(
        Uri.parse("$baseUrl/users"),
        headers: headers,
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
          "role": role,
        }),
      ),
    );

    return handleResponse(res);
  }

  static Future deleteUser(int id) async {
    final res = await safeRequest(
      http.delete(Uri.parse("$baseUrl/users/$id"), headers: headers),
    );

    return handleResponse(res);
  }

  // ================= KNN =================
  static Future submitNilai(Map data) async {
    final res = await safeRequest(
      http.post(
        Uri.parse("$baseUrl/rekomendasi"),
        headers: headers,
        body: jsonEncode(data),
      ),
    );

    return handleResponse(res);
  }

  // ================= NILAI K =================
  static Future getK() async {
    final res = await safeRequest(
      http.get(Uri.parse("$baseUrl/knn-settings/k"), headers: headers),
    );

    return handleResponse(res);
  }

  static Future setK(int k) async {
    final res = await safeRequest(
      http.post(
        Uri.parse("$baseUrl/knn-settings/k"),
        headers: headers,
        body: jsonEncode({"k": k}),
      ),
    );

    return handleResponse(res);
  }

  // ================= STATISTIK =================
  static Future getStatistics() async {
    final res = await safeRequest(
      http.get(Uri.parse("$baseUrl/statistics"), headers: headers),
    );

    return handleResponse(res);
  }

  // ================= DATA TRAINING =================
  static Future<List> getTrainingData() async {
    final res = await safeRequest(
      http.get(Uri.parse("$baseUrl/training"), headers: headers),
    );

    return handleResponse(res);
  }

  static Future addTraining(Map data) async {
    final res = await safeRequest(
      http.post(
        Uri.parse("$baseUrl/training"),
        headers: headers,
        body: jsonEncode(data),
      ),
    );

    return handleResponse(res);
  }

  static Future updateTraining(
      int id, String nama, double ipk, String bidang) async {
    final res = await safeRequest(
      http.put(
        Uri.parse("$baseUrl/training/$id"),
        headers: headers,
        body: jsonEncode({
          "nama": nama,
          "ipk": ipk,
          "bidang_minat": bidang,
        }),
      ),
    );

    return handleResponse(res);
  }

  static Future deleteTraining(int id) async {
    final res = await safeRequest(
      http.delete(Uri.parse("$baseUrl/training/$id"), headers: headers),
    );

    return handleResponse(res);
  }
}