import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:whatsapp_project/core/network/ui_state.dart';
import 'package:whatsapp_project/models/user_model.dart';

import '../../models/contact_item.dart';
import '../../routes/app_screens.dart';

/// Created by Vertika Mishra

class SearchContactController extends GetxController {
  final contactList = UiState<List<UserModel>>.none().obs;
  final searchTextController = TextEditingController();

  Future<void> searchContact(String userName) async {
    contactList.value = UiState.loading();
    print("loading");
    final result = await FirebaseDatabase.instance
        .ref('users')
        .orderByChild('userName')
        .startAt(userName)
        .limitToFirst(10)
        .once();
    print("result=${result.snapshot.children.length}");
    final data = result.snapshot.children
        .map((e) => UserModel.fromSnapshot(e))
        .skipWhile(
          (value) => value.uid == FirebaseAuth.instance.currentUser?.uid,
        )
        .toList();
    print("length=${data.length}");
    if (data.isEmpty) {
      contactList.value = UiState.error("No user exist");
    } else {
      contactList.value = UiState.success(data);
    }
  }

  Future<void> addToContact(UserModel item) async {
    final contact = Contact(name: item.name??"", image: item.image??"", uid: item.uid??"");
    final dbRef = FirebaseDatabase.instance
        .ref("contacts")
        .child(FirebaseAuth.instance.currentUser?.uid ?? "0");

    final data = await dbRef.child(item.uid??"0").once();

    if (data.snapshot.value==null) {
      await dbRef.child(item.uid??"0").set(contact.toJson());
    }
    Get.offAndToNamed(AppScreens.chatDetails, arguments: contact);
  }


}
