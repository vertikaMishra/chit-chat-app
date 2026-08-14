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
    contactList.value = UiState.loading();
    contactSubscription = FirebaseDatabase.instance
        .ref("contacts/${FirebaseAuth.instance.currentUser!.uid}")
        .onValue
        .listen((event) {
          if (event.snapshot.children.isEmpty) {
            contactList.value = UiState.error("no data found");
            return;
          }
          final contacts = event.snapshot.children
              .map((e) => Contact.fromJson(e))
              .toList();

          contactList.value = UiState.success(contacts);

          filteredContacts.assignAll(contacts);
          print(
            "=================> ${contactList.value.getDataOrNull()?.length}",
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
