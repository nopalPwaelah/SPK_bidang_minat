import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/config/api_config.dart';

class ApiService {
  static String get baseUrl => ApiConfig.baseUrl;

  static String? token;
  static String? currentUsername;

  // =====================================
  // HEADER
  // =====================================

  static Map<String, String> get headers => {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

  // =====================================
  // HANDLE RESPONSE
  // =====================================

  static dynamic handleResponse(http.Response res) {
    print("URL: ${res.request?.url}");

    print("STATUS: ${res.statusCode}");

    print("BODY: ${res.body}");

    dynamic data = {};

    if (res.body.isNotEmpty) {
      data = jsonDecode(res.body);
    }

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return data;
    }

    throw Exception(data["detail"] ?? "Server error");
  }

  // =====================================
  // SAFE REQUEST
  // =====================================

  static Future<http.Response> safeRequest(
      Future<http.Response> request) async {
    try {
      return await request.timeout(
        const Duration(seconds: 15),
      );
    } catch (e) {
      throw Exception("Tidak bisa konek ke server: $e");
    }
  }

  // =====================================
  // LOGIN
  // =====================================

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
      currentUsername = data["username"]?.toString();
    }

    return data;
  }

  // =====================================
  // REGISTER
  // =====================================

  static Future register(String username, String email, String password) async {
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

  // =====================================
  // USERS
  // =====================================

  static Future<List> getUsers() async {
    final res = await safeRequest(
      http.get(
        Uri.parse("$baseUrl/users"),
        headers: headers,
      ),
    );

    return handleResponse(res);
  }

  static Future deleteUser(int id) async {
    final res = await safeRequest(
      http.delete(
        Uri.parse("$baseUrl/users/$id"),
        headers: headers,
      ),
    );

    return handleResponse(res);
  }

  // =====================================
  // TRAINING DATA
  // =====================================

  static Future<List> getTrainingData() async {
    final res = await safeRequest(
      http.get(
        Uri.parse("$baseUrl/training"),
        headers: headers,
      ),
    );

    return handleResponse(res);
  }

  static Future addTraining(Map<String, dynamic> data) async {
    final res = await safeRequest(
      http.post(
        Uri.parse("$baseUrl/training"),
        headers: headers,
        body: jsonEncode(data),
      ),
    );

    return handleResponse(res);
  }

  static Future updateTraining(int id, Map<String, dynamic> data) async {
    final res = await safeRequest(
      http.put(
        Uri.parse("$baseUrl/training/$id"),
        headers: headers,
        body: jsonEncode(data),
      ),
    );

    return handleResponse(res);
  }

  static Future deleteTraining(int id) async {
    final res = await safeRequest(
      http.delete(
        Uri.parse("$baseUrl/training/$id"),
        headers: headers,
      ),
    );

    return handleResponse(res);
  }

  // =====================================
  // STATISTICS
  // =====================================

  static Future getStatistics() async {
    final res = await safeRequest(
      http.get(
        Uri.parse("$baseUrl/training/stats/summary"),
        headers: headers,
      ),
    );

    return handleResponse(res);
  }

  static Future getYearlyStatistics() async {
    final res = await safeRequest(
      http.get(
        Uri.parse("$baseUrl/training/stats/yearly"),
        headers: headers,
      ),
    );

    return handleResponse(res);
  }

  // =====================================
  // KNN PREDICT
  // =====================================

  static Future submitNilai(Map<String, dynamic> data) async {
    final res = await safeRequest(
      http.post(
        Uri.parse("$baseUrl/rekomendasi/predict"),
        headers: headers,
        body: jsonEncode(data),
      ),
    );

    return handleResponse(res);
  }

  // =====================================
  // HISTORY
  // =====================================

  static Future<List> getPredictionHistory() async {
    final res = await safeRequest(
      http.get(
        Uri.parse("$baseUrl/rekomendasi/history"),
        headers: headers,
      ),
    );

    return handleResponse(res);
  }

  static Future deleteHistory(int id) async {
    final res = await safeRequest(
      http.delete(
        Uri.parse("$baseUrl/rekomendasi/history/$id"),
        headers: headers,
      ),
    );

    return handleResponse(res);
  }

  static Future getPredictionSummary() async {
    final res = await safeRequest(
      http.get(
        Uri.parse("$baseUrl/rekomendasi/history/summary"),
        headers: headers,
      ),
    );

    return handleResponse(res);
  }

  // =====================================
  // K VALUE
  // =====================================

  static Future getK() async {
    final res = await safeRequest(
      http.get(
        Uri.parse("$baseUrl/knn-settings/k"),
        headers: headers,
      ),
    );

    return handleResponse(res);
  }

  static Future setK(int nilaiK) async {
    final res = await safeRequest(
      http.put(
        Uri.parse("$baseUrl/knn-settings/k"),
        headers: headers,
        body: jsonEncode({"nilai_k": nilaiK}),
      ),
    );

    return handleResponse(res);
  }

  // =====================================
  // KNN CONFIGURATION
  // =====================================

  static Future getKNNConfiguration() async {
    final res = await safeRequest(
      http.get(
        Uri.parse("$baseUrl/knn-settings/configuration"),
        headers: headers,
      ),
    );

    return handleResponse(res);
  }

  static Future updateKNNConfiguration(Map<String, dynamic> config) async {
    final res = await safeRequest(
      http.put(
        Uri.parse("$baseUrl/knn-settings/configuration"),
        headers: headers,
        body: jsonEncode(config),
      ),
    );

    return handleResponse(res);
  }

  static Future getKNNMetrics() async {
    final res = await safeRequest(
      http.get(
        Uri.parse("$baseUrl/knn-settings/metrics"),
        headers: headers,
      ),
    );

    return handleResponse(res);
  }

  static Future addUser(
    String username,
    String email,
    String password,
    String role,
  ) async {
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
}
