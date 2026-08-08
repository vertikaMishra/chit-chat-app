import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_project/core/network/ui_state.dart';
import 'package:whatsapp_project/models/message_item.dart';

import '../../models/contact_item.dart';

/// Created by Vertika Mishra

class ChatDetailsController extends GetxController {
  final Contact contact = Get.arguments;
  final RxnString animatedEmoji = RxnString();
  final messageList = Rx<UiState<List<MessageItem>>>(UiState.none());
  StreamSubscription<DatabaseEvent>? newMessageSubscription;
  StreamSubscription<DatabaseEvent>? updateMessageSubscription;
  final msgDbRef = FirebaseDatabase.instance.ref("messages");
  final conDbRef = FirebaseDatabase.instance.ref("contacts");

  final messageController = TextEditingController();

  final Rxn<MessageItem> replyMessage = Rxn<MessageItem>();

  void startReply(MessageItem message) {
    replyMessage.value = message;

    Get.snackbar(
      "Reply",
      "Replying to: ${message.text}",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void cancelReply() {
    replyMessage.value = null;
  }

  void showEmojiAnimation(String emoji) {
    animatedEmoji.value = emoji;
  }

  void hideEmojiAnimation() {
    animatedEmoji.value = null;
  }

  @override
  void onReady() {
    getMessages();
    super.onReady();
  }

  Future sendMessage(String text) async {
    final key = msgDbRef.push().key ?? DateTime.now().toString();

    final newMassage = MessageItem(
      senderId: FirebaseAuth.instance.currentUser!.uid,
      text: text,
      timestamp: DateTime.now().microsecondsSinceEpoch,
      type: MessageType.text,
      status: MessageStatus.sending,
      msgId: key,

      // Reply information
      replyToMessageId: replyMessage.value?.msgId,
      replyToText: replyMessage.value?.text,
    );

    final list = <MessageItem>[];
    list.add(newMassage);

    if (messageList.value.getDataOrNull() != null) {
      list.addAll(messageList.value.getDataOrNull()!);
    }

    messageList.value = UiState.success(list);

    final req3 = conDbRef
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(contact.uid ?? "")
        .update({
      "message": text,
      "time": DateTime.now().microsecondsSinceEpoch.toString(),
      "count": 0,
    });

    final req4 = conDbRef
        .child(contact.uid)
        .child(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "name": FirebaseAuth.instance.currentUser!.displayName,
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "image": FirebaseAuth.instance.currentUser!.photoURL,
      "message": text,
      "time": DateTime.now().microsecondsSinceEpoch.toString(),
      "count": ServerValue.increment(1),
    });

    final map = newMassage.toJson();

    map['status'] = MessageStatus.sent.name;

    final req1 = msgDbRef
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(contact.uid)
        .child(key)
        .set(map);

    final req2 = msgDbRef
        .child(contact.uid)
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(key)
        .set(map);

    await Future.wait([req1, req2, req3, req4]);

    replyMessage.value = null;
  }

  void getMessages() {
    newMessageSubscription = msgDbRef
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(contact.uid)
        .onChildAdded
        .listen((event) {
          final newMassage = MessageItem.fromSnapshot(event.snapshot);

          final oldMessages = <MessageItem>[];
          if (messageList.value.getDataOrNull() != null) {
            oldMessages.addAll(messageList.value.getDataOrNull()!);
          }
          oldMessages.removeWhere(
            (element) => element.msgId == newMassage.msgId,
          );
          oldMessages.insert(0, newMassage);
          messageList.value = UiState.success(oldMessages);
          if (newMassage.senderId != FirebaseAuth.instance.currentUser!.uid) {
            conDbRef
                .child(FirebaseAuth.instance.currentUser!.uid)
                .child(contact.uid)
                .update({"count": 0});
            msgDbRef
                .child(contact.uid)
                .child(FirebaseAuth.instance.currentUser!.uid)
                .child(newMassage.msgId)
                .update({"status": MessageStatus.read.name});
          }
        });
    updateMessageSubscription = msgDbRef
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(contact.uid)
        .onChildChanged
        .listen((event) {
          final massage = MessageItem.fromSnapshot(event.snapshot);

          final messages = <MessageItem>[];
          if (messageList.value.getDataOrNull() != null) {
            messages.addAll(messageList.value.getDataOrNull()!);
          }
          final index = messages.indexWhere(
            (element) => element.msgId == massage.msgId,
          );
          messages.removeAt(index);
          messages.insert(index, massage);
          messageList.value = UiState.success(messages);
        });
  }

  @override
  void onClose() {
    updateMessageSubscription?.cancel();
    newMessageSubscription?.cancel();
    super.onClose();
  }

  Future<void> clearchat() async {
    final confirmed = await Get.dialog(
      AlertDialog(
        title: const Text("Clear chat"),
        content: const Text(
          "Are you sure you want to clear all messages in this chat? "
          "This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Clear"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await msgDbRef
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child(contact.uid)
          .remove();

      await conDbRef
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child(contact.uid)
          .update({"message": null, "time": null, "count": 0});

      messageList.value = UiState.success([]);
    }
  }

  /// Add or change reaction to a message
  Future<void> addReaction(MessageItem message, String reaction) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Update my copy
    await msgDbRef
        .child(currentUserId)
        .child(contact.uid)
        .child(message.msgId)
        .update({"reaction": reaction});

    // Update receiver's copy
    await msgDbRef
        .child(contact.uid)
        .child(currentUserId)
        .child(message.msgId)
        .update({"reaction": reaction});
  }
}
