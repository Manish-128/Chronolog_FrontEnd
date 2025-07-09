// import 'package:chronolog/screens/dashboard.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MaterialApp(
//     home: DashboardScreen(),
//     debugShowCheckedModeBanner: false,
//   ));
// }


import 'package:chronolog/screens/dashboard.dart';
import 'package:chronolog/screens/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
    );
  }
}