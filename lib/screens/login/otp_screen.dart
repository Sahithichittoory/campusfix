
import 'package:flutter/material.dart';
import 'change_password.dart'; // your ResetPasswordModal

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

    await Future.delayed(const Duration(seconds: 1)); // simulate API call

    if (otp == "642892") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP Verified Successfully")),
      );

      Navigator.pop(context); // Close OTP modal

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) =>
            ChangePasswordScreen(authToken: '', rollNo: widget.rollNo),
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
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Material(
          color: Colors.transparent,
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                  child:
                  Container(height: 5, width: 40, color: Colors.grey[300])),
              const SizedBox(height: 20),
              const Text(
                "Enter 6 Digit Code",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter the 6-digit code sent to your email.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                      (index) => SizedBox(
                    width: 45,
                    child: TextField(
                      controller: otpControllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
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
              const SizedBox(height: 25),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _verifyOtp,
                child: const Text("Continue"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
