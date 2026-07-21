import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:whatsapp_project/core/network/ui_state.dart';

import '../../../models/contact_item.dart';

/// Created by Vertika Mishra

class ChatCantroller extends GetxController {
  final contactList = Rx<UiState<List<Contact>>>(UiState.none());
  StreamSubscription<DatabaseEvent>? contactSubscription;

  Future<void> getContactList() async {
    contactList.value = UiState.loading();
    contactSubscription =  FirebaseDatabase.instance
        .ref("contacts/${FirebaseAuth.instance.currentUser!.uid}")
        .onValue
        .listen((event) {
          contactList.value = UiState.success(
            event.snapshot.children.map((e) => Contact.fromJson(e)).toList(),
          );
        });
  }

  @override
  void onReady() {
    getContactList();
    super.onReady();
  }

  @override
  void onClose() {
    contactSubscription?.cancel();
    super.onClose();
  }
}
