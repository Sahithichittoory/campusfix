
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangePasswordProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<String?> changePassword(
      String rollNo, {
        required String currentPassword,
        required String newPassword,
        required String authToken,
      }) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('http://54.177.10.216:5000/api/updatepassword');

    final body = jsonEncode({
      'roll_no': rollNo,
      'newPassword': newPassword,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: body,
      );

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        return null;
      } else {
        final data = jsonDecode(response.body);
        return data['error'] ?? 'Failed to change password';
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Error: $e';
    }
  }
}
