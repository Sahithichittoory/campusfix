import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:project_spacee/screens/login/forgot%20password.dart';
import 'package:project_spacee/screens/login/sign_in.dart';
import 'package:project_spacee/screens/student/history.dart';
import 'package:project_spacee/screens/student/student_home_screen.dart';
import 'package:project_spacee/services/issuemodal.dart';

import 'package:shared_preferences/shared_preferences.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, IssueModel? issue});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String rollNo = '';
  String blockNo = '';
  String roomNo = '';
  String mobileNo = '';
  String profileImage = '';
  String category = '';
  String description = '';
  String image = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStudentData();
  }

  Future<void> loadStudentData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      rollNo = prefs.getString('rollNo') ?? '';
      blockNo = prefs.getString('blockNo') ?? '';
      roomNo = prefs.getString('roomNo') ?? '';
      mobileNo = prefs.getString('mobileNo') ?? '';
      profileImage = prefs.getString('profileImage') ?? '';
      category = prefs.getString('latestCategory') ?? '';
      description = prefs.getString('latestDescription') ?? '';
      image = prefs.getString('latestImage') ?? '';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFEC5F6),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          /// Background with blur
          Container(
            height: size.height * 0.4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFC562AF), Color(0xFFB33791)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.transparent),
            ),
          ),

          /// Foreground Content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 60),

                /// Profile Image
                CircleAvatar(
                  radius: size.width * 0.22,
                  backgroundColor: Colors.white,
                  backgroundImage: profileImage.isNotEmpty
                      ? NetworkImage(profileImage)
                      : null,
                  child: profileImage.isEmpty
                      ? const Icon(Icons.person,
                      size: 80, color: Color(0xFFC562AF))
                      : null,
                ),
                const SizedBox(height: 20),

                /// Name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                /// Info Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color.fromARGB(255, 215, 64, 115)
                          .withOpacity(0.85),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow("Roll No", rollNo),
                      _infoRow("Block No", blockNo),
                      _infoRow("Room No", roomNo),
                      _infoRow("Mobile No", mobileNo),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// History Button (Large)
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => History(
                            category: category,
                            description: description,
                            imageData: image,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDB8DD0),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "History",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Change Password Button (Medium)
                SizedBox(
                  width: 200,
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDB8DD0),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => ForgotPasswordModal(),
                      );
                    },
                    child: const Text(
                      "Change Password",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Logout Button (Small)
                SizedBox(
                  width: 130,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignIn(),
                        ),
                      );
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF3D3D3D),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF3D3D3D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}