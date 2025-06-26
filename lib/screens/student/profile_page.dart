import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login/forgot password.dart';
import '../login/sign_in.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          Container(
            height: size.height * 0.6,
            color: Colors.lightBlue[300],
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.12),
                CircleAvatar(
                    radius: size.width * 0.22,
                    backgroundImage: profileImage.isNotEmpty
                        ? NetworkImage(profileImage)
                        : null),
                SizedBox(height: size.height * 0.030),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: size.width * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Container(
                  width: size.width * 0.9,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.03,
                        horizontal: size.width * 0.06,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow("Roll No", rollNo, size),
                          _infoRow("Block No", blockNo, size),
                          _infoRow("Room No", roomNo, size),
                          _infoRow("Mobile No", mobileNo, size),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: size.width * 0.06),
                  child: Column(
                    children: [
                      _button(
                          context, "Change Password", Colors.lightBlue),
                      SizedBox(height: size.height * 0.02),
                      _button(context, "Logout", Colors.redAccent),
                    ],
                  ),
                ),
                SizedBox(
                    height:
                    size.height * 0.12), // leave space for bottom bar
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.008),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size.width * 0.045,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: size.width * 0.045,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(BuildContext context, String text, Color color) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.06,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          if (text == "Logout") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SignIn()),
            );
          } else if (text == "Change Password") {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => ForgotPasswordModal(),
            );
          }
        },
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}