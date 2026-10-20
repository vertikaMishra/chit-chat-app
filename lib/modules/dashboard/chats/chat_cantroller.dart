import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:whatsapp_project/core/network/ui_state.dart';

import '../../../models/contact_item.dart';

/// Created by Vertika Mishra

class ChatCantroller extends GetxController {
  final contactList = Rx<UiState<List<Contact>>>(UiState.none());
  StreamSubscription<DatabaseEvent>? contactSubscription;
  final searchController = TextEditingController();
  final RxString searchText = ''.obs;

  final RxList<Contact> filteredContacts = <Contact>[].obs;

  Future<void> getContactList() async {
    print("🔥 Starting contacts load...");

    contactList.value = UiState.loading();

    final contactRef = FirebaseDatabase.instance
        .ref("contacts/${FirebaseAuth.instance.currentUser!.uid}");

    try {
      print("🔥 Testing Firebase connection...");

      final testSnapshot = await contactRef
          .get()
          .timeout(const Duration(seconds: 10));

      print("🔥 Firebase responded!");
      print("🔥 Data exists: ${testSnapshot.exists}");
      print("🔥 Number of contacts: ${testSnapshot.children.length}");
    } catch (e) {
      print("❌ Firebase contact test failed: $e");
    }

    contactSubscription = contactRef.onValue.listen((event) {
      print("🔥 Firebase contacts response received!");

      if (event.snapshot.children.isEmpty) {
        contactList.value = UiState.error("no data found");
        return;
      }

      final contacts = event.snapshot.children
          .map((e) => Contact.fromJson(e))
          .toList();

      print("🔥 Contacts converted: ${contacts.length}");

      contactList.value = UiState.success(contacts);
      filteredContacts.assignAll(contacts);
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

  void searchContacts(String query) {
    searchText.value = query;

    if (query.trim().isEmpty) {
      filteredContacts.assignAll(
        contactList.value.getDataOrNull() ?? [],
      );
      return;
    }

    final searchTextValue = query.toLowerCase().trim();

    final contacts = contactList.value.getDataOrNull() ?? [];

    final result = contacts.where((contact) {
      final name = contact.name?.toLowerCase() ?? "";
      final message = contact.message?.toLowerCase() ?? "";

      return name.contains(searchTextValue) ||
          message.contains(searchTextValue);
    }).toList();

    filteredContacts.assignAll(result);
  }
  void clearSearch() {
    searchController.clear();
    searchText.value = '';

    filteredContacts.assignAll(
      contactList.value.getDataOrNull() ?? [],
    );
  }
}
