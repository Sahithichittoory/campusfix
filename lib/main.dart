import 'package:flutter/material.dart';
import 'package:project_spacee/providers/block_provider.dart';
import 'package:project_spacee/providers/change_password.dart';
import 'package:project_spacee/providers/profile.dart';
import 'package:project_spacee/providers/theme_provider.dart';
import 'package:project_spacee/screens/on_boarding_screen.dart';
import 'package:project_spacee/services/category_service.dart';
import 'package:project_spacee/services/student_service.dart';

import 'package:provider/provider.dart';
// import 'package:device_preview/device_preview.dart'; // Commented out for production

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryCountProvider()),
        ChangeNotifierProvider(create: (_) => BlockProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
        ChangeNotifierProvider(create: (_) => StudentProfileProvider()),
      ],
      child: const MyApp(),
    ),

    // Uncomment below if you want to enable Device Preview again:
    /*
    DevicePreview(
      enabled: true, // Disable in production
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CategoryCountProvider()),
          ChangeNotifierProvider(create: (_) => BlockProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
          ChangeNotifierProvider(create: (_) => StudentProfileProvider()),
        ],
        child: const MyApp(),
      ),
    ),
    */
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // builder: DevicePreview.appBuilder, // Commented out for production
      useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context), // Commented out for production
      debugShowCheckedModeBanner: false,
      title: 'Campus Fix',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const OnboardingScreen(), // Starting screen
    );
  }
}
