/// Created by Vertika Mishra

import 'package:flutter/material.dart';
import '../../models/contact_item.dart';

class GuessMeGameScreen extends StatelessWidget {
  final Contact friend;

  const GuessMeGameScreen({super.key, required this.friend});

  Widget _answerButton(String answer) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: OutlinedButton(
        onPressed: () {
          // Answer logic will be added next
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 18),
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFE0E0E0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            answer,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF1D385C),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Guess Me 🧠")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Text(
              "Let's see how well you know ${friend.name ?? "your friend"} 🧠",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D385C),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Question 1 of 3",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 35),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                "What do you think your friend would choose? 🤔",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
            ),

            const SizedBox(height: 25),

            _answerButton("☕ Coffee"),
            _answerButton("🍵 Tea"),
            _answerButton("🥤 Cold Drink"),
          ],
        ),
      ),
    );
  }
}
