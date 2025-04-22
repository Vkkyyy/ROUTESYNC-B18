import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:routesyncui/const.dart';

class ApiService {
  static Future<Map<String, dynamic>> registerStudent({
    required String name,
    required String email,
    required String rollNo,
    required int year,
    required String course,
    required String busStop,
    required String phoneNumber,
    String? routeNo,
  }) async {
    final Uri url = Uri.parse(addUser);

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "roll_no": rollNo,
          "year": year,
          "course": course,
          "bus_stop": busStop,
          "phone_number": phoneNumber,
          "route_no": routeNo?.isNotEmpty == true ? routeNo : null,
          "password": "Student@123", // Set default password
        }),
      );

      if (response.statusCode == 200) {
        // Extract only the first valid JSON object
        String responseBody = response.body.trim();
        int firstJsonEnd = responseBody.indexOf("}{");

        if (firstJsonEnd != -1) {
          responseBody = responseBody.substring(0, firstJsonEnd + 1);
        }

        final Map<String, dynamic> responseData = jsonDecode(responseBody);
        return responseData;
      } else {
        return {
          "status": "error",
          "message": "Server responded with status: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"status": "error", "message": "Exception: ${e.toString()}"};
    }
  }
}
