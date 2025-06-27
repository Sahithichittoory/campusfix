import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  final String _adminEmail = 'admin@example.com';
  final String _adminPassword = 'admin123';

  final String studentLoginUrl = 'http://16.16.105.136:5000/api/userlogin';

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

  Future<Map<String, dynamic>> login(String username, String password) async {
    // Admin login check (hardcoded)
    if (username == _adminEmail && password == _adminPassword) {
      _userData = {
        'role': 'admin',
        'email': _adminEmail,
        'name': 'Admin',
      };
      notifyListeners();
      return {
        'code': 200,
        'role': 'admin',
        'message': 'Admin login successful',
      };
    }

    // Student login via MongoDB API
    try {
      final response = await http.post(
        Uri.parse(studentLoginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'roll_no': username,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successful login (based only on status code)
        _userData = data['user'];
        notifyListeners();
        return {
          'code': response.statusCode,
          'role': 'student',
          'message': data['message'] ?? 'Student login successful',
          'user': data['user'],
          'token': data['token']
        };
      } else {
        // Login failed
        return {
          'code': response.statusCode,
          'message': data['message'] ?? 'Invalid credentials',
        };
      }
    } catch (e) {
      // API/network error
      return {
        'code': 500,
        'message': 'Login error: $e',
      };
    }
  }

  void logout() {
    _userData = null;
    notifyListeners();
  }
}