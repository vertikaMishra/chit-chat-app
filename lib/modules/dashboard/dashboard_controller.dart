import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_project/models/user_model.dart';

/// Created by Vertika Mishra
class DashboardController extends GetxController {
  final Rx<UserModel?> userData=Rx(null);
  Future<void> getUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    final result = await FirebaseDatabase.instance
        .ref("users")
        .child(userId)
        .once();
    userData.value=UserModel.fromSnapshot(result.snapshot);
  }

  @override
  void onReady() {
    getUserData();
    super.onReady();
  }

  Future<void> checkUpdateUserName(String userName) async {
    if(isValidUsername(userName)==false){
      Get.snackbar(
        'Error',
        "username is not valid",
        snackPosition: SnackPosition.BOTTOM,
        overlayColor: Colors.red,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
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
    getUserData();
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
    getUserData();
    Get.back();
  }

}
