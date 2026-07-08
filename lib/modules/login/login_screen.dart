import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Created by Vertika Mishra

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Container(
              width: double.infinity,
              height: 600,
              child: CachedNetworkImage(
                imageUrl:
                    "https://static.vecteezy.com/system/resources/previews/016/900/444/non_2x/online-dating-app-login-illustration-valentine-s-day-love-match-mobile-leaves-gradient-character-illustration-vector.jpg",
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
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
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22,60,0,0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(Size(480,60)),
                    backgroundColor: WidgetStatePropertyAll(Colors.tealAccent),
                    foregroundColor: WidgetStatePropertyAll(Colors.black),
                    textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 30)),
                  ),
                  child: Text("Login here!"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
