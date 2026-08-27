/// Created by Vertika Mishra

import 'package:flutter/material.dart';
import '../../models/contact_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class GuessMeGameScreen extends StatefulWidget {
  final Contact friend;

  const GuessMeGameScreen({super.key, required this.friend});

  @override
  State<GuessMeGameScreen> createState() => _GuessMeGameScreenState();
}

class _GuessMeGameScreenState extends State<GuessMeGameScreen> {
  String selectedAnswer = "";
  int currentQuestion = 0;
  int score = 0;
  String? gameId;

  @override
  void initState() {
    super.initState();
    createGame();
  }

  Future<void> saveAnswer(String answer) async {
    if (gameId == null) return;

    await FirebaseDatabase.instance
        .ref("guessMe/games/$gameId/answers")
        .child("creator")
        .child("q${currentQuestion + 1}")
        .set(answer);
  }

  Future<void> createGame() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return;

    final gameRef =
    FirebaseDatabase.instance.ref("guessMe/games").push();

    gameId = gameRef.key;

    await gameRef.set({
      "creatorUid": uid,
      "friendUid": widget.friend.uid,
      "friendName": widget.friend.name,
      "status": "waiting",
      "createdAt": ServerValue.timestamp,
    });
  }

  final List<Map<String, dynamic>> questions = [
    {
      "question": "What do you think your friend would choose? 🤔",
      "options": ["☕ Coffee", "🍵 Tea", "🥤 Cold Drink"],
    },
    {
      "question": "What would your friend prefer? 🎮",
      "options": ["🎬 Movies", "🎮 Gaming", "🎵 Music"],
    },
    {
      "question": "Where would your friend rather go? 🌍",
      "options": ["🏖️ Beach", "🏔️ Mountains", "🏙️ City"],
    },
  ];

  final List<String> correctAnswers = [
    "☕ Coffee",
    "🎮 Gaming",
    "🏔️ Mountains",
  ];

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
              "Let's see how well you know "
              "${widget.friend.name ?? "your friend"} 🧠",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D385C),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Question ${currentQuestion + 1} of ${questions.length}",
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
              child: Text(
                questions[currentQuestion]["question"],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
            ),

            const SizedBox(height: 25),

            ...List<String>.from(
              questions[currentQuestion]["options"],
            ).map((answer) => _answerButton(answer)),
            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedAnswer.isEmpty
                    ? null
                    : () async {
                        await saveAnswer(selectedAnswer);
                        if (selectedAnswer == correctAnswers[currentQuestion]) {
                          score++;
                        }

                        setState(() {
                          if (currentQuestion < questions.length - 1) {
                            currentQuestion++;
                            selectedAnswer = "";
                          } else {
                            _showResult();
                          }
                        });
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFFFFC857),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Next Question →",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _answerButton(String answer) {
    final isSelected = selectedAnswer == answer;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            selectedAnswer = answer;
          });
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 18),
          backgroundColor: isSelected ? const Color(0xFF1D385C) : Colors.white,
          side: BorderSide(
            color: isSelected
                ? const Color(0xFF1D385C)
                : const Color(0xFFE0E0E0),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.white : const Color(0xFF1D385C),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _showResult() {
    String message;

    if (score == 3) {
      message = "You know your friend really well! 🥳";
    } else if (score == 2) {
      message = "Pretty good! 🔥";
    } else if (score == 1) {
      message = "You need to chat more! 😄";
    } else {
      message = "Looks like you need to know them better! 😂";
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Center(
            child: Text(
              "🏆 Game Complete!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$score / ${questions.length}",
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D385C),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC857),
                  foregroundColor: const Color(0xFF1D385C),
                ),
                child: const Text("Done"),
              ),
            ),
          ],
        );
      },
    );
  }
}
