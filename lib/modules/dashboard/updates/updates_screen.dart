import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_project/routes/app_screens.dart';

class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1D385C),
        title: const Text(
          "Activities✨",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Make conversations more fun 🎉",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D385C),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Play, laugh and discover how well your friends know you.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 22),

          // Guess Me
          _featureCard(
            icon: "🧠",
            title: "Guess Me",
            description:
            "Think you know your friend? Guess what they would choose!",
            buttonText: "Play Now",
            gradient: const [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
            ],
            onTap: () {
              Get.toNamed(AppScreens.guessMe);
            },
          ),

          const SizedBox(height: 16),

          // Conversation Roulette
          _featureCard(
            icon: "🎭",
            title: "Conversation Roulette",
            description:
            "Spin the wheel and get a random challenge for your friend.",
            buttonText: "Try It",
            gradient: const [
              Color(0xFF00A896),
              Color(0xFF0077B6),
            ],
            onTap: () {
              Get.snackbar(
                "Roulette 🎭",
                "Coming soon!",
              );
            },
          ),

          const SizedBox(height: 16),

          // Inside Joke Vault
          _featureCard(
            icon: "😂",
            title: "Inside Joke Vault",
            description:
            "Save those funny moments and inside jokes you never want to forget.",
            buttonText: "Open Vault",
            gradient: const [
              Color(0xFFFF9966),
              Color(0xFFFF5E62),
            ],
            onTap: () {
              Get.snackbar(
                "Joke Vault 😂",
                "Coming soon!",
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _featureCard({
    required String icon,
    required String title,
    required String description,
    required String buttonText,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 42),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 18),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: gradient.last,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}
