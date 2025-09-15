import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:3000";

  static Future<String?> login(String email, String password) async {
    try {
      final response = await http
          .post(
        Uri.parse("$baseUrl/api/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'] as String?;
      } else {
        print('Login Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Login Exception: $e');
      return null;
    }
  }

  static Future<List<dynamic>> getUsers(String token) async {
    try {
      final response = await http
          .get(
        Uri.parse("$baseUrl/api/auth/users"),
        headers: {"Authorization": "Bearer $token"},
      )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        print('Get Users Error: ${response.statusCode} - ${response.body}');
        throw Exception("Failed to load users");
      }
    } catch (e) {
      print('Get Users Exception: $e');
      throw e;
    }
  }
}