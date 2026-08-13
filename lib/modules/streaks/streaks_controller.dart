/// Created by Vertika Mishra

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../../models/contact_item.dart';

class StreaksController extends GetxController {
  final RxList<Contact> contacts = <Contact>[].obs;
  final RxBool isLoading = false.obs;

  final DatabaseReference contactsRef = FirebaseDatabase.instance.ref(
    "contacts",
  );

  StreamSubscription<DatabaseEvent>? contactsSubscription;

  @override
  void onReady() {
    super.onReady();
    listenToContacts();
  }

  void listenToContacts() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      contacts.clear();
      return;
    }

    isLoading.value = true;

    contactsSubscription = contactsRef
        .child(userId)
        .onValue
        .listen(
          (event) {
            final snapshot = event.snapshot;

            if (!snapshot.exists || snapshot.value == null) {
              contacts.clear();
              isLoading.value = false;
              return;
            }

            final value = snapshot.value;

            if (value is! Map) {
              contacts.clear();
              isLoading.value = false;
              return;
            }

            final loadedContacts = <Contact>[];

            for (final entry in value.entries) {
              final contactValue = entry.value;

              if (contactValue is Map) {
                final map = Map<dynamic, dynamic>.from(contactValue);

                loadedContacts.add(
                  Contact(
                    name: map["name"]?.toString(),
                    image: map["image"]?.toString(),
                    message: map["message"]?.toString(),
                    time: map["time"]?.toString(),
                    count: map["count"] is num ? map["count"] as num : null,
                    uid: map["uid"]?.toString() ?? entry.key.toString(),

                    streak: int.tryParse(map["streak"]?.toString() ?? "0") ?? 0,

                    lastMessageDate: map["lastMessageDate"]?.toString(),
                  ),
                );
              }
            }

            contacts.assignAll(loadedContacts);
            isLoading.value = false;
          },
          onError: (error) {
            isLoading.value = false;

            Get.snackbar("Error", "Unable to load streaks");
          },
        );
  }

  // Still useful for your refresh button
  Future<void> loadContacts() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      contacts.clear();
      return;
    }

    try {
      isLoading.value = true;

      final snapshot = await contactsRef.child(userId).get();

      if (!snapshot.exists || snapshot.value == null) {
        contacts.clear();
        return;
      }

      final value = snapshot.value;

      if (value is! Map) {
        contacts.clear();
        return;
      }

      final loadedContacts = <Contact>[];

      for (final entry in value.entries) {
        final contactValue = entry.value;

        if (contactValue is Map) {
          final map = Map<dynamic, dynamic>.from(contactValue);

          loadedContacts.add(
            Contact(
              name: map["name"]?.toString(),
              image: map["image"]?.toString(),
              message: map["message"]?.toString(),
              time: map["time"]?.toString(),
              count: map["count"] is num ? map["count"] as num : null,
              uid: map["uid"]?.toString() ?? entry.key.toString(),

              streak: int.tryParse(map["streak"]?.toString() ?? "0") ?? 0,

              lastMessageDate: map["lastMessageDate"]?.toString(),
            ),
          );
        }
      }

      contacts.assignAll(loadedContacts);
    } catch (e) {
      Get.snackbar("Error", "Unable to load streaks");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    contactsSubscription?.cancel();
    super.onClose();
  }
}
