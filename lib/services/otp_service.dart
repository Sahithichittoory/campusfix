// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class OtpService {
//   static Future<bool> sendOtpRequestOnly(String rollNo) async {
//     final url = Uri.parse('http://54.177.10.216:5000/api/campus-fix/send-otp');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({"roll_no": rollNo, "otp": "642892"}),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data["message"] == "WhatsApp OTP sent successfully!";
//     } else {
//       return false;
//     }
//   }

//   static Future<bool> sendOtpByRollNumber(String rollNo, String otp) async {
//     final url = Uri.parse('http://54.177.10.216:5000/api/campus-fix/send-otp');

//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({"roll_no": rollNo, "otp": otp}),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data["message"] == "WhatsApp OTP sent successfully!";
//     } else {
//       return false;
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;

class OtpService {
  // General method for sending OTP based on ID type
  static Future<bool> sendOtpRequestOnly(String id,
      {bool isAdmin = false}) async {
    final url = Uri.parse('http://54.177.10.216:5000/api/campus-fix/send-otp');

    final body = isAdmin
        ? {"employeeId": id, "otp": "642892"}
        : {"roll_no": id, "otp": "642892"};

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["message"] == "WhatsApp OTP sent successfully!";
    } else {
      return false;
    }
  }

  // Optional: OTP method with custom OTP value
  static Future<bool> sendOtpById(String id, String otp,
      {bool isAdmin = false}) async {
    final url = Uri.parse('http://54.177.10.216:5000/api/campus-fix/send-otp');

    final body =
    isAdmin ? {"employeeId": id, "otp": otp} : {"roll_no": id, "otp": otp};

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["message"] == "WhatsApp OTP sent successfully!";
    } else {
      return false;
    }
  }
}