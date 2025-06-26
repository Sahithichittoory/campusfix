

import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserData(Map<String, dynamic> userData) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString('rollNo', userData['roll_no']);
  await prefs.setString('name', userData['name']);
  await prefs.setString('mobile', userData['mobile']);
  await prefs.setString('room', userData['room_no']);
  await prefs.setString('block', userData['hostel_block']);
  await prefs.setString('email', userData['email']);
}