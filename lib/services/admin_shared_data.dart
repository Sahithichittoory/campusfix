import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveAdminData(Map<String, dynamic> adminData) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString('adminId', adminData['employeeId'] ?? '');
  await prefs.setString('adminName', adminData['name'] ?? '');
  await prefs.setString('adminEmail', adminData['email'] ?? '');
  await prefs.setString('adminMobile', adminData['mobile'] ?? '');

  print('✅ Admin data saved to SharedPreferences');
}