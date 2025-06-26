import 'package:flutter/material.dart';
import 'package:project_spacee/providers/block_provider.dart';
import 'package:project_spacee/providers/change_password.dart';
import 'package:project_spacee/providers/profile.dart';
import 'package:project_spacee/providers/theme_provider.dart';
import 'package:project_spacee/screens/login/sign_in.dart';
import 'package:project_spacee/services/student_service.dart';
import 'package:provider/provider.dart';
// import 'package:device_preview/device_preview.dart'; // ❌ Commented out

void main() {
  runApp(
    // DevicePreview(
    //   enabled: true, // Disable in production
    //   builder: (context) =>
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BlockProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
        ChangeNotifierProvider(create: (_) => StudentProfileProvider()),
      ],
      child: const MyApp(),
    ),
    // ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // builder: DevicePreview.appBuilder, // ❌ Commented out
      // useInheritedMediaQuery: true, // ❌ Commented out
      // locale: DevicePreview.locale(context), // ❌ Commented out
      debugShowCheckedModeBanner: false,
      title: 'Campus Fix',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const SignIn(),
    );
  }
}
