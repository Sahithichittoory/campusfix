import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/change_password.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String authToken;
  final String rollNo;

  const ChangePasswordScreen({
    super.key,
    required this.authToken,
    required this.rollNo,
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isNewVisible = false;
  bool isConfirmVisible = false;

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (!formKey.currentState!.validate()) return;

    final provider =
    Provider.of<ChangePasswordProvider>(context, listen: false);

    final error = await provider.changePassword(
      widget.rollNo,
      currentPassword: '', // Not needed in your API request
      newPassword: newPasswordController.text.trim(),
      authToken: widget.authToken,
    );

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully!')),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<ChangePasswordProvider>(context).isLoading;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.green.shade50.withOpacity(0.5),
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(color: Colors.transparent),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          height: 5,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Reset Password",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Set the new password for your account so you can login and access all the features.",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // New Password
                      TextFormField(
                        controller: newPasswordController,
                        obscureText: !isNewVisible,
                        validator: (value) {
                          if (value == null || value.length < 8) {
                            return 'Minimum 8 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Password',
                          filled: true,
                          fillColor: Colors.grey[100],
                          suffixIcon: IconButton(
                            icon: Icon(
                              isNewVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() => isNewVisible = !isNewVisible);
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Confirm Password
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: !isConfirmVisible,
                        validator: (value) {
                          if (value != newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          filled: true,
                          fillColor: Colors.grey[100],
                          suffixIcon: IconButton(
                            icon: Icon(
                              isConfirmVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(
                                      () => isConfirmVisible = !isConfirmVisible);
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleChangePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            padding:
                            const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text(
                            "Reset Password",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}