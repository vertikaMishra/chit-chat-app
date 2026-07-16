import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_project/modules/dashboard/calls/calls_screen.dart';
import 'package:whatsapp_project/modules/dashboard/communities/communities_screen.dart';
import 'package:whatsapp_project/modules/dashboard/updates/updates_screen.dart';

import 'chats/chat_screen.dart';
import '../../models/contact_item.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        return IndexedStack(
          index: currentIndex.value,
          children: [
            ChatScreen(),
            UpdatesScreen(),
            CommunitiesScreen(),
            CallsScreen(),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: currentIndex.value,
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.black,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          onTap: (value) {
            currentIndex.value = value;
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined, size: 30),
              label: "Chats",
              activeIcon: Icon(Icons.message, color: Colors.green),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.donut_large_outlined, size: 30),
              label: "Updates",
              activeIcon: Icon(Icons.donut_large, color: Colors.green),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_outlined, size: 30),
              label: "Communities",
              activeIcon: Icon(Icons.groups, color: Colors.green),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.call_outlined, size: 30),
              label: "Calls",
              activeIcon: Icon(Icons.call, color: Colors.green),
            ),
          ],
        );
      }),
    );
  }
}
