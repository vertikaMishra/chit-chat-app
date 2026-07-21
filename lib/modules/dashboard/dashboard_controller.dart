import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Created by Vertika Mishra
class DashboardController extends GetxController {
  Future<void> checkUpdateUserName(String userName) async {
    final result = await FirebaseDatabase.instance
        .ref("users")
        .orderByChild("userName")
        .equalTo(userName)
        .once();
    if (result.snapshot.children.isNotEmpty) {
      Get.snackbar(
        'Error',
        "username already taken",
        snackPosition: SnackPosition.BOTTOM,
        overlayColor: Colors.red,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    final userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    await FirebaseDatabase.instance.ref('users').child(userId).update({
      'userName':userName,
    });
    Get.back();
  }


  bool isValidUsername(String username) {
    final regex = RegExp(
      r'^(?=.{3,20}$)(?!._)[A-Za-z][A-Za-z0-9][A-Za-z0-9]$',
    );
    return regex.hasMatch(username);
  }
  Future<void> updateProfile({required String name, String? bio}) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    await FirebaseDatabase.instance.ref('users').child(userId).update({
      'name': name,
      'bio': bio,
    });
    Get.back();
  }
}
