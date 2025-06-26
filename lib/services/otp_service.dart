import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
class OtpService {
  static Future<bool> sendOtpRequestOnly(String rollNo) async {
    final url = Uri.parse('http://54.177.10.216:5000/api/campus-fix/send-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"roll_no": rollNo, "otp": "642892"}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["message"] == "WhatsApp OTP sent successfully!";
    } else {
      return false;
    }
  }

  static Future<bool> sendOtpByRollNumber(String rollNo, String otp) async {
    final url = Uri.parse('http://54.177.10.216:5000/api/campus-fix/send-otp');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"roll_no": rollNo, "otp": otp}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["message"] == "WhatsApp OTP sent successfully!";
    } else {
      return false;
    }
  }
}