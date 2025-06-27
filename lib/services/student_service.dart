import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentProfileProvider with ChangeNotifier {
  String name = '';
  String rollNo = '';
  String blockNo = '';
  String roomNo = '';
  int mobileNo = 0;
  String profileImage = '';

  void setStudentData(Map<String, dynamic> data) {
    name = data['name'] ?? '';
    rollNo = data['roll_no'] ?? '';
    blockNo = data['block'] ?? '';
    roomNo = data['room_no'] ?? '';
    mobileNo = data['mobile'] ?? '';
    profileImage = data['profile_image'] ?? '';
    notifyListeners();
  }

  void clear() {
    name = '';
    rollNo = '';
    blockNo = '';
    roomNo = '';
    mobileNo = 0;
    profileImage = '';
    notifyListeners();
  }
}