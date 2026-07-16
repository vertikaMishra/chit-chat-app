import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:whatsapp_project/modules/login/login_Controller.dart';

/// Created by Vertika Mishra

class LoginScreen extends GetView<LoginController> {
    const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBCD6BD),
      body: Column(
        children: [

          Expanded(
            child: Image.asset(
               "images/ChitChatnewt.jpg.png"
            ),
          ),
          Text(
            "Let's get started",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 35,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 28, 0),
            child: Text(
              "Welcome to ChitChat!! We're thrilled to have you. Tap the login Button to start your first chat or explore new features.",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: 56),
          SizedBox(
            height: 56,
            width: 280,
            child: SignInButton(Buttons.googleDark, onPressed: () {
              controller.signInWithGoogle(context);
            },),
          ),
          SizedBox(height: 56),
        ],
      ),
    );
  }
}
