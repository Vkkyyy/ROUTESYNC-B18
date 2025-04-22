import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StudentService {
  final String baseUrl = "http://192.168.0.101:5000/api/student";

  // Fetch student details
  Future<Map<String, dynamic>?> fetchStudentDetails() async {
    final url = Uri.parse("$baseUrl/student-details");

    try {
      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        print("No token found. Please login first.");
        return null;
      }

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print("Failed to fetch student details: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error fetching student details: $e");
      return null;
    }
  }
}
