import 'package:flutter/material.dart';
import 'package:whatsapp_project/modules/dashboard/dashboard_screen.dart';
import 'package:whatsapp_project/modules/login/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Whatsapp",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          surfaceTint: Colors.white,
        ),
      ),
      home: LoginScreen(),
    );
  }
}


