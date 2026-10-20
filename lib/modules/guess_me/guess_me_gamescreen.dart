/// Created by Vertika Mishra

import 'package:flutter/material.dart';
import '../../models/contact_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class GuessMeGameScreen extends StatefulWidget {
  final Contact friend;
  final String gameId;
  final bool isCreator;

  const GuessMeGameScreen({
    super.key,
    required this.friend,
    required this.gameId,
    required this.isCreator,
  });

  @override
  State<GuessMeGameScreen> createState() => _GuessMeGameScreenState();
}

class _GuessMeGameScreenState extends State<GuessMeGameScreen> {
  String selectedAnswer = "";
  int currentQuestion = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> saveAnswer(String answer) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception("User is not logged in");
    }

    final gameRef = FirebaseDatabase.instance.ref(
      "guessMe/games/${widget.gameId}",
    );

    final snapshot = await gameRef.get();

    if (!snapshot.exists || snapshot.value is! Map) {
      throw Exception("Game not found");
    }

    final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

    final creatorUid = data["creatorUid"]?.toString();
    final friendUid = data["friendUid"]?.toString();

    // Identify which player is answering.
    final String playerType;

    if (currentUser.uid == creatorUid) {
      playerType = "creator";
    } else if (currentUser.uid == friendUid) {
      playerType = "friend";
    } else {
      throw Exception("You are not a participant in this game");
    }

    // Save the answer under the correct player's account.
    await gameRef
        .child("answers/$playerType/q${currentQuestion + 1}")
        .set(answer);
  }

  final List<Map<String, dynamic>> questions = [
    {
      "question": "What's your favourite drink? ☕",
      "options": ["☕ Coffee", "🍵 Tea", "🥤 Cold Drink"],
    },
    {
      "question": "What do you enjoy most? 🎮",
      "options": ["🎬 Movies", "🎮 Gaming", "🎵 Music"],
    },
    {
      "question": "Where would you love to go? 🌍",
      "options": ["🏖️ Beach", "🏔️ Mountains", "🏙️ City"],
    },
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
                widget.isCreator
                    ? questions[currentQuestion]["question"]
                    : questions[currentQuestion]["question"]
                          .toString()
                          .replaceFirst("your", "your friend's"),
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
                        try {
                          await saveAnswer(selectedAnswer);
                        } catch (e) {
                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Unable to save your answer. Please try again.",
                              ),
                            ),
                          );
                          return;
                        }

                        if (currentQuestion < questions.length - 1) {
                          setState(() {
                            currentQuestion++;
                            selectedAnswer = "";
                          });
                        } else {
                          if (widget.isCreator) {
                            // Player A has finished answering.
                            await FirebaseDatabase.instance
                                .ref("guessMe/games/${widget.gameId}")
                                .update({
                                  "creatorAnswersReady": true,
                                  "phase": "guessing",
                                });

                            if (!mounted) return;

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (dialogContext) => AlertDialog(
                                title: const Text("Answers Saved! 🎉"),
                                content: const Text(
                                  "Your answers are saved. Ask your friend to accept "
                                  "the invitation and guess your choices!",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Done"),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            try {
                              final gameRef = FirebaseDatabase.instance.ref(
                                "guessMe/games/${widget.gameId}",
                              );

                              final snapshot = await gameRef.get();

                              if (!snapshot.exists || snapshot.value is! Map) {
                                throw Exception("Game not found");
                              }

                              final data = Map<dynamic, dynamic>.from(
                                snapshot.value as Map,
                              );

                              // Player A must finish before Player B can score.
                              if (data["creatorAnswersReady"] != true) {
                                if (!mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Your friend hasn't finished answering yet!",
                                    ),
                                  ),
                                );
                                return;
                              }

                              final answers = Map<dynamic, dynamic>.from(
                                data["answers"] as Map,
                              );

                              final creatorAnswers = Map<dynamic, dynamic>.from(
                                answers["creator"] as Map,
                              );

                              final friendAnswers = Map<dynamic, dynamic>.from(
                                answers["friend"] as Map,
                              );

                              // Compare Player B's guesses with Player A's answers.
                              int finalScore = 0;

                              for (int i = 1; i <= questions.length; i++) {
                                if (creatorAnswers["q$i"] ==
                                    friendAnswers["q$i"]) {
                                  finalScore++;
                                }
                              }

                              // Save the score and mark the game as completed.
                              await gameRef.update({
                                "scores/friend": finalScore,
                                "phase": "completed",
                              });

                              if (!mounted) return;

                              setState(() {
                                score = finalScore;
                              });

                              _showResult();
                            } catch (e) {
                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Unable to calculate the score. Please try again.",
                                  ),
                                ),
                              );
                            }
                          }
                        }
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
