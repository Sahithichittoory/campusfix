import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_spacee/services/form_service.dart';
import 'package:project_spacee/services/issuemodal.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      _selectedIndex = 2; // Go to Profile after submission
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

// Form Screen with callback
class IssueFormScreen extends StatefulWidget {
  final Function(IssueModel) onSubmit;

  const IssueFormScreen({super.key, required this.onSubmit});

  @override
  _IssueFormScreenState createState() => _IssueFormScreenState();
}

class _IssueFormScreenState extends State<IssueFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? category, description;
  String rollNo = '', blockNo = '', roomNo = '';
  File? _imageFile;
  String? _base64Image;
  Uint8List? _webImageData;
  Key _dropdownKey = UniqueKey();

  final categories = [
    'Electricity',
    'Plumbing',
    'Wi-Fi',
    'Furniture',
    'Food',
    'Other'
  ];

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  void initState() {
    super.initState();
    loadStudentInfo();
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

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final responseData = await ApiService.addComplaint(
          category: category!,
          description: description!,
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
            description: description!,
            imageBytes: imageBytes,
          ));

          _formKey.currentState!.reset();
          setState(() {
            category = null;
            description = null;
            _imageFile = null;
            _base64Image = null;
            _dropdownKey = UniqueKey();
          });

          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Success"),
              content: Text(
                  responseData['message'] ?? "Issue submitted successfully!"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text("OK"))
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
              Text(responseData?['message'] ?? "Failed to submit issue"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Something went wrong. Please try again")),
        );
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
          borderSide: const BorderSide(color: Color(0xFFB33791)),
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
              getGreeting(),
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
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
                      validator: (val) =>
                      val == null ? "Select category" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: _inputDecoration(
                          "Describe the Issue", Icons.description),
                      maxLines: 4,
                      validator: (val) => val!.length < 10
                          ? "Describe at least 10 characters"
                          : null,
                      onSaved: (val) => description = val,
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