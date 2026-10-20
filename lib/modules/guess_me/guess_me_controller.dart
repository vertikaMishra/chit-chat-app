/// Created by Vertika Mishra

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../../models/contact_item.dart';

class GuessMeController extends GetxController {
  // All contacts that can be selected for the game
  final RxList<Contact> contacts = <Contact>[].obs;

  // Selected friend
  final Rx<Contact?> selectedContact = Rx<Contact?>(null);

  // Temporary questions
  final List<Map<String, dynamic>> questions = [
    {
      "question": "What would your friend choose?",
      "options": ["☕ Coffee", "🍵 Tea", "🥤 Cold Drink"],
    },
    {
      "question": "What would your friend prefer?",
      "options": ["🎬 Movie", "🎮 Gaming", "🎵 Music"],
    },
    {
      "question": "Where would your friend rather go?",
      "options": ["🏖️ Beach", "🏔️ Mountains", "🏙️ City"],
    },
  ];

  // Current question number
  final RxInt currentQuestion = 0.obs;

  // Current score
  final RxInt score = 0.obs;

  // Selected answer
  final RxString selectedAnswer = ''.obs;

  @override
  void onReady() {
    super.onReady();
    loadContacts();
  }

  void selectFriend(Contact contact) {
    selectedContact.value = contact;
  }

  Future<String?> createGame() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return null;
    }

    final friend = selectedContact.value;

    if (friend == null || friend.uid == null || friend.uid!.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select a friend first",
      );
      return null;
    }

    final gameRef =
    FirebaseDatabase.instance.ref("guessMe/games").push();

    final gameId = gameRef.key;

    if (gameId == null) {
      return null;
    }

    await gameRef.set({
      "creatorUid": currentUser.uid,
      "creatorName": currentUser.displayName ?? "Your friend",
      "friendUid": friend.uid,
      "friendName": friend.name,
      "status": "waiting",
      "createdAt": ServerValue.timestamp,
    });

    return gameId;
  }

  Future<void> loadContacts() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return;
    }

    try {
      final snapshot = await FirebaseDatabase.instance
          .ref("contacts/$userId")
          .get();

      if (!snapshot.exists) {
        contacts.clear();
        return;
      }

      final loadedContacts = snapshot.children.map((e) {
        final value = Map<dynamic, dynamic>.from(e.value as Map);

        return Contact(
          uid: value["uid"]?.toString() ?? e.key ?? "",
          name: value["name"]?.toString() ?? "Unknown",
          image: value["image"]?.toString(),
          message: value["message"]?.toString(),
          time: value["time"]?.toString(),
          count: value["count"] is num ? value["count"] as num : null,
        );
      }).toList();

      contacts.assignAll(loadedContacts);
    } catch (e) {
      Get.snackbar("Error", "Unable to load contacts");
    }
  }

  void selectAnswer(String answer) {
    selectedAnswer.value = answer;
  }

  void nextQuestion() {
    if (currentQuestion.value < questions.length - 1) {
      currentQuestion.value++;
      selectedAnswer.value = '';
    }
  }

  void resetGame() {
    selectedContact.value = null;
    currentQuestion.value = 0;
    score.value = 0;
    selectedAnswer.value = '';
  }
}
