import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  static Future<Map<String, dynamic>?> loginUser(
      String rollNo, String password) async {
    final url = Uri.parse('http://54.177.10.216:5000/api/userlogin');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'roll_no': rollNo,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data; // return user data
    } else {
      return null;
    }
  }
}
//   static Future<bool> loginUser(String rollNo, String password) async {
//     final url = Uri.parse('http://54.177.10.216:5000/api/userlogin');

//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'roll_no': rollNo,
//         'password': password,
//       }),
//     );

//     if (response.statusCode == 200) {
//       // You may also want to decode and return the token or user type
//       return true;
//     } else {
//       return false;
//     }
//   }
