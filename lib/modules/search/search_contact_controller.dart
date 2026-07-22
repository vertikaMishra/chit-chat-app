import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:whatsapp_project/core/network/ui_state.dart';
import 'package:whatsapp_project/models/user_model.dart';

/// Created by Vertika Mishra

class SearchContactController extends GetxController {
  final contactList = UiState<List<UserModel>>.none().obs;
  final searchTextController = TextEditingController();

  Future<void> searchContact(String userName) async {
    contactList.value = UiState.loading();
    final result = await FirebaseDatabase.instance
        .ref('users')
        .orderByChild('userName')
        .startAt(userName)
        .limitToFirst(10)
        .once();
    final data = result.snapshot.children
        .map((e) => UserModel.fromSnapshot(e))
        .skipWhile(
          (value) => value.uid == FirebaseAuth.instance.currentUser?.uid,
        )
        .toList();
    if (data.isEmpty) {
      contactList.value = UiState.error("No user exist");
    } else {
      contactList.value = UiState.success(data);
    }
  }
}
