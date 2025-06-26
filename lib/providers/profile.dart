import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileProvider extends ChangeNotifier {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  String _name = "";
  String _role = "";

  File? get imageFile => _imageFile;
  String get name => _name;
  String get role => _role;

  void setProfileData({required String name, required String role}) {
    _name = name;
    _role = role;
    notifyListeners();
  }

  void updateName(String name) {
    _name = name;
    notifyListeners();
  }

  void updateRole(String role) {
    _role = role;
    notifyListeners();
  }

  Future<void> pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }
}