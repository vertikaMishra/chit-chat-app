/// Created by Vertika Mishra

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'streaks_controller.dart';

class StreaksScreen extends GetView<StreaksController> {
  const StreaksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1D385C),
        foregroundColor: Colors.white,
        title: const Text(
          "Your Streaks 🔥",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: controller.loadContacts,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // =========================
          // MAIN STREAK SUMMARY
          // =========================
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF9966), Color(0xFFFF5E62)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                // Dynamic emoji based on longest streak
                Obx(() {
                  final longestStreak = controller.contacts.isEmpty
                      ? 0
                      : controller.contacts
                            .map((contact) => contact.streak)
                            .reduce((a, b) => a > b ? a : b);

                  return Text(
                    _getStreakEmoji(longestStreak),
                    style: const TextStyle(fontSize: 65),
                  );
                }),

                const SizedBox(height: 5),

                const Text(
                  "Your longest streak",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),

                const SizedBox(height: 5),

                // Dynamic longest streak number
                Obx(() {
                  final currentLongestStreak = controller.contacts.isEmpty
                      ? 0
                      : controller.contacts
                            .map((contact) => contact.streak)
                            .reduce((a, b) => a > b ? a : b);

                  return Text(
                    "$currentLongestStreak",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),

                const SizedBox(height: 5),

                const Text(
                  "Keep the conversation alive! 💬",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "🔥 Active Streaks",
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D385C),
            ),
          ),

          const SizedBox(height: 12),

          // =========================
          // CONTACT STREAKS
          // =========================
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.contacts.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "No contacts available yet 💬",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ),
              );
            }

            return Column(
              children: controller.contacts.map((contact) {
                return _streakCard(
                  name: contact.name ?? "Unknown",
                  streak: contact.streak,
                  emoji: _getStreakEmoji(contact.streak),
                  level: contact.streak == 0
                      ? "Start chatting"
                      : contact.streak < 3
                      ? "Getting started 🌱"
                      : contact.streak < 7
                      ? "On fire 🔥"
                      : contact.streak < 15
                      ? "Hot streak 🔥🔥"
                      : contact.streak < 30
                      ? "Rising 💎"
                      : contact.streak < 100
                      ? "Legendary 👑"
                      : "Ultimate 🏆",
                );
              }).toList(),
            );
          }),

          const SizedBox(height: 25),

          const Text(
            "🏆 Streak Levels",
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D385C),
            ),
          ),

          const SizedBox(height: 12),

          _levelCard("3 Days", "🌱", "Starter"),
          _levelCard("7 Days", "🔥", "Hot"),
          _levelCard("15 Days", "💎", "Rising"),
          _levelCard("30 Days", "👑", "Legendary"),
          _levelCard("100 Days", "🏆", "Ultimate"),
        ],
      ),
    );
  }

  // =====================================
  // STREAK EMOJI FUNCTION
  // =====================================
  String _getStreakEmoji(int streak) {
    if (streak == 0) {
      return "💬";
    } else if (streak < 3) {
      return "🌱";
    } else if (streak < 7) {
      return "🔥";
    } else if (streak < 15) {
      return "🔥🔥";
    } else if (streak < 30) {
      return "💎";
    } else if (streak < 100) {
      return "👑";
    } else {
      return "🏆";
    }
  }

  // =====================================
  // STREAK CARD
  // =====================================
  Widget _streakCard({
    required String name,
    required int streak,
    required String emoji,
    required String level,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFFFFE4D6),
            child: Text(emoji, style: const TextStyle(fontSize: 27)),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "$level • Keep chatting!",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),

          Column(
            children: [
              Text(
                "🔥 $streak",
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                "days",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================
  // STREAK LEVEL CARD
  // =====================================
  Widget _levelCard(String days, String emoji, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 27)),

          const SizedBox(width: 14),

          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),

          const Spacer(),

          Text(
            days,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
