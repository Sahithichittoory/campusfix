import 'dart:ui';
import 'package:flutter/material.dart';
import 'change_password.dart';

class OTPModal extends StatefulWidget {
  final String rollNo;
  const OTPModal({super.key, required this.rollNo});

  @override
  State<OTPModal> createState() => _OTPModalState();
}

class _OTPModalState extends State<OTPModal> {
  final List<TextEditingController> otpControllers =
  List.generate(6, (_) => TextEditingController());

  bool _isLoading = false;

  void _verifyOtp() async {
    final otp = otpControllers.map((e) => e.text.trim()).join();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the 6-digit OTP")),
      );
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1)); // Simulate API

    if (otp == "642892") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP Verified Successfully")),
      );
      Navigator.pop(context); // Close OTP modal

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color.fromARGB(0, 245, 244, 244),
        builder: (_) => ChangePasswordScreen(
          authToken: '',
          rollNo: widget.rollNo,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.2, sigmaY: 0.2),
            child: Container(
              color: Color.fromARGB(255, 245, 107, 153).withOpacity(0.4),
            ),
          ),

          // OTP Draggable Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.35,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag Handle
                      Center(
                        child: Container(
                          height: 4,
                          width: 40,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const Text(
                        "Enter the 6-digit code sent to your Mobile No.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          6,
                              (index) => SizedBox(
                            width: 45,
                            height: 55,
                            child: TextField(
                              controller: otpControllers[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: const TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.isEmpty && index > 0) {
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      _isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Color.fromARGB(255, 245, 107, 153)
                                .withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text(
                            "Continue",
                            style: TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}