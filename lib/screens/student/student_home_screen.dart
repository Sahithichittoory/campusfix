import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project_spacee/services/form_service.dart';
import 'package:project_spacee/services/issuemodal.dart'; // Make sure this file contains only one IssueModel definition

import 'notify_page.dart';
import 'profile_page.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _selectedIndex = 0;
  IssueModel? _submittedIssue;

  void _onIssueSubmitted(IssueModel issue) {
    setState(() {
      _submittedIssue = issue;
      _selectedIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      IssueFormScreen(onSubmit: _onIssueSubmitted),
      const NotificationPage(),
      ProfileScreen(issue: _submittedIssue),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFEC5F6),
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 65,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFC562AF),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.notifications,
                  color: _selectedIndex == 1 ? Colors.white : Colors.white70),
              onPressed: () => setState(() => _selectedIndex = 1),
            ),
            IconButton(
              icon: Icon(Icons.home,
                  color: _selectedIndex == 0 ? Colors.white : Colors.white70),
              onPressed: () => setState(() => _selectedIndex = 0),
            ),
            IconButton(
              icon: Icon(Icons.person,
                  color: _selectedIndex == 2 ? Colors.white : Colors.white70),
              onPressed: () => setState(() => _selectedIndex = 2),
            ),
          ],
        ),
      ),
    );
  }
}

class IssueFormScreen extends StatefulWidget {
  final Function(IssueModel) onSubmit;

  const IssueFormScreen({super.key, required this.onSubmit});

  @override
  _IssueFormScreenState createState() => _IssueFormScreenState();
}

class _IssueFormScreenState extends State<IssueFormScreen> {
  final _formKey = GlobalKey<FormState>();
  // Removed 'description' state variable as controller will be the source of truth
  String? category;
  String rollNo = '', blockNo = '', roomNo = '';
  File? _imageFile;
  Uint8List? _webImageData;
  Key _dropdownKey = UniqueKey();

  // Add a TextEditingController for the description field
  final TextEditingController _descriptionController = TextEditingController();

  final categories = [
    'Electricity',
    'Plumbing',
    'Wi-Fi',
    'Furniture',
    'Food',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    loadStudentInfo();
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is removed
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> loadStudentInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rollNo = prefs.getString('rollNo') ?? '';
      blockNo = prefs.getString('blockNo') ?? '';
      roomNo = prefs.getString('roomNo') ?? '';
    });
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _webImageData = bytes;
          _imageFile = null;
        });
      } else {
        setState(() {
          _imageFile = File(picked.path);
          _webImageData = null;
        });
      }
    }
  }

  void _showTopMessage(String message, {Color backgroundColor = Colors.green}) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Material(
          color: backgroundColor,
          elevation: 8,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 3), () => entry.remove());
  }

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      // No need to call _formKey.currentState!.save() for description if we use controller.text directly
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final responseData = await ApiService.addComplaint(
          category: category!,
          description: _descriptionController.text, // Get text directly from controller
          rollNo: rollNo,
          blockNo: blockNo,
          roomNo: roomNo,
          path: _imageFile?.path,
        );

        Navigator.of(context).pop();

        if (responseData != null && responseData['status'] == true) {
          final imageBytes =
          _imageFile != null ? await _imageFile!.readAsBytes() : null;

          widget.onSubmit(IssueModel(
            category: category!,
            description: _descriptionController.text, // Use controller text for IssueModel
            imageBytes: imageBytes,
          ));

          // Reset the form fields and controller
          _formKey.currentState!.reset(); // Resets validation and dropdown state
          _descriptionController.clear(); // Clears the text field explicitly

          setState(() {
            category = null; // Clear selected category
            _imageFile = null; // Clear selected image
            _webImageData = null; // Clear web image data
            _dropdownKey = UniqueKey(); // Force rebuild dropdown to show hint
          });

          _showTopMessage("Issue submitted successfully!",
              backgroundColor: Colors.green);
        } else {
          _showTopMessage(
            responseData?['message'] ?? "Failed to submit issue",
            backgroundColor: Colors.red,
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        _showTopMessage("Something went wrong. Please try again",
            backgroundColor: Colors.red);
      }
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) =>
      InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFB33791)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB33791), width: 2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEC5F6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Text(
              "Hello!",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFFB33791),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFDB8DD0),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      key: _dropdownKey,
                      decoration:
                      _inputDecoration("Issue Category", Icons.report),
                      value: category,
                      onChanged: (val) => setState(() => category = val),
                      items: categories
                          .map((cat) =>
                          DropdownMenuItem(value: cat, child: Text(cat)))
                          .toList(),
                      validator: (val) => val == null ? "Select category" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController, // Assign the controller
                      decoration:
                      _inputDecoration("Describe the Issue", Icons.description),
                      maxLines: 4,
                      // Updated validator to also check for emptiness
                      validator: (val) => val!.isEmpty || val.length < 10
                          ? "Describe at least 10 characters"
                          : null,
                      // Removed onSaved as we directly use _descriptionController.text
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text("Upload Image"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC562AF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    if (_imageFile != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _imageFile!,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    // For web image display, add this condition
                    if (kIsWeb && _webImageData != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            _webImageData!,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: submitForm,
                      child: const Text("Submit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB33791),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}