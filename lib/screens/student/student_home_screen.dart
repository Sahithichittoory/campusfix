import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/form_service.dart';
import 'notify_page.dart';
import 'profile_page.dart';
import 'dart:typed_data';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _selectedIndex = 0;

  Widget _buildHomePage(BuildContext context) {
    return const IssueFormScreen();
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen;
    if (_selectedIndex == 0) {
      currentScreen = _buildHomePage(context);
    } else if (_selectedIndex == 1) {
      currentScreen = SolvedScreen();
    } else {
      currentScreen = const ProfileScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1B1444),
      body: currentScreen,
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF2E1A64),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none,
                          color: Colors.white),
                      onPressed: () => setState(() => _selectedIndex = 1),
                    ),
                    IconButton(
                      icon:
                      const Icon(Icons.group_outlined, color: Colors.white),
                      onPressed: () => setState(() => _selectedIndex = 2),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: const Offset(0, -25),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 0),
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.pinkAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Icon(Icons.home_outlined, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IssueFormScreen extends StatefulWidget {
  const IssueFormScreen({super.key});

  @override
  _IssueFormScreenState createState() => _IssueFormScreenState();
}

class _IssueFormScreenState extends State<IssueFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? category, description;
  String rollNo = '';
  String blockNo = '';
  String roomNo = '';
  File? _imageFile;
  Uint8List? _webImageData;

  final categories = [
    'Electricity',
    'Plumbing',
    'Wi-Fi',
    'Furniture',
    'Food',
    'Other'
  ];
  Key _dropdownKey = UniqueKey();
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

      // Show loading dialog
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

        Navigator.of(context).pop(); // Close loading

        if (responseData != null && responseData['status'] == true) {
          _formKey.currentState!.reset();
          setState(() {
            category = null;
            description = null;
            _imageFile = null;
            _webImageData = null;
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
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        } else {
          // Handle failure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
              Text(responseData?['message'] ?? "Failed to submit issue"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        Navigator.of(context).pop(); // Close loading
        print("Submit Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Something went wrong. Please try again")),
        );
      }
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.deepPurple),
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyle(color: Colors.grey[800]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.deepPurple),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F2FF),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 32,
              vertical: isSmallScreen ? 12 : 24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5D9F2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.deepPurple.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "CampusFix - Issue Form",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 20 : 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          key: _dropdownKey,
                          decoration:
                          _inputDecoration("Issue Category", Icons.report),
                          value: category,
                          onChanged: (val) => setState(() => category = val),
                          items: categories
                              .map((cat) => DropdownMenuItem(
                              value: cat, child: Text(cat)))
                              .toList(),
                          validator: (val) =>
                          val == null ? "Select category" : null,
                          style: const TextStyle(color: Colors.black87),
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
                          style: const TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.image, color: Colors.white),
                          label: const Text("Upload Image",
                              style: TextStyle(color: Colors.white)),
                          onPressed: pickImage,
                        ),
                        if (_imageFile != null || _webImageData != null) ...[
                          const SizedBox(height: 12),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: kIsWeb
                                  ? (_webImageData != null
                                  ? Image.memory(_webImageData!,
                                  height: 160)
                                  : const Text("No image selected"))
                                  : (_imageFile != null
                                  ? Image.file(_imageFile!, height: 160)
                                  : const Text("No image selected")),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: submitForm,
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}