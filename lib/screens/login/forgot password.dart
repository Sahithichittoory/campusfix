import 'dart:math';
import 'package:flutter/material.dart';
import 'package:project_spacee/services/otp_service.dart';
import 'otp_screen.dart';

class ForgotPasswordModal extends StatefulWidget {
  const ForgotPasswordModal({super.key});

  @override
  State<ForgotPasswordModal> createState() => _ForgotPasswordModalState();
}

class _ForgotPasswordModalState extends State<ForgotPasswordModal> {
  final TextEditingController rollNumberController = TextEditingController();
  bool _isLoading = false;

  void _sendOtp() async {
    final roll = rollNumberController.text.trim();

    if (roll.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Roll number cannot be empty")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final sent = await OtpService.sendOtpRequestOnly(roll);

      if (sent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP sent successfully")),
        );

        Navigator.pop(context); // Close modal before navigating

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OTPModal(rollNo: roll)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send OTP")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: ListView(
          controller: scrollController,
          children: [
            Center(
                child:
                Container(height: 5, width: 40, color: Colors.grey[300])),
            const SizedBox(height: 20),
            const Text("Forgot Password",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
                "Enter your roll number to receive a 6-digit verification code."),
            const SizedBox(height: 20),
            TextField(
              controller: rollNumberController,
              decoration: const InputDecoration(
                labelText: "Roll Number",
                hintText: "Enter your registered roll number",
                suffixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(400))),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _sendOtp,
              child: const Text(
                "Continue",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                Color.fromARGB(255, 245, 107, 153).withOpacity(0.4),
                minimumSize: const Size(20, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}