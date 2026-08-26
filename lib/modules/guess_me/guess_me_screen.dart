/// Created by Vertika Mishra

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'guess_me_controller.dart';
import 'guess_me_gamescreen.dart';

class GuessMeScreen extends GetView<GuessMeController> {
  const GuessMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1D385C),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Guess Me 🧠",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            const Text(
              "Who do you want to play with?",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D385C),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Choose a friend and find out how well you know each other! 💙",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 25),

            Obx(() {
              if (controller.contacts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "No contacts available yet 💬",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                );
              }

              return Column(
                children: controller.contacts.map((contact) {
                  return _friendCard(
                    name: contact.name ?? "Unknown",
                    onTap: () {
                      controller.selectFriend(contact);

                      Get.to(
                            () => GuessMeGameScreen(
                          friend: contact,
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _friendCard({required String name, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xFFE8EAF6),
              child: Icon(Icons.person, color: Color(0xFF5C6BC0), size: 30),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1D385C),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Play",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
