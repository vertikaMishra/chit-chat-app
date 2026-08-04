import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_project/models/message_item.dart';
import 'package:whatsapp_project/modules/chat_details/chat_details_controller.dart';

import '../../core/ext.dart';

/// Created by Vertika Mishra

class ChatDetailsScreen extends GetView<ChatDetailsController> {
  const ChatDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("======>${FirebaseAuth.instance.currentUser?.uid}");
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFE2CFBF),
      appBar: AppBar(
        backgroundColor: Color(0xFF1D385C),
        foregroundColor: Colors.white,
        title: Text(controller.contact.name ?? ""),
        actions: [IconButton(onPressed: () {
          controller.clearchat();
        }, icon: Icon(Icons.delete_outline_outlined))],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return controller.messageList.value.when(
                none: () => SizedBox.shrink(),
                loading: () => Center(child: CircularProgressIndicator()),
                error: (msg) => Text(msg),
                success: (data) => ListView.builder(
                  itemCount: data.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return MessageBubble(item: item);
                  },
                ),
              );
            }),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "message here",
                        filled: true,
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton.filledTonal(
                    style: IconButton.styleFrom(backgroundColor: Colors.green),
                    color: Colors.white,
                    onPressed: () {
                      if (controller.messageController.text.isNotEmpty) {
                        controller.sendMessage(
                          controller.messageController.text.trim(),
                        );
                      }
                      controller.messageController.clear();
                    },
                    icon: Icon(Icons.send_rounded, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.item});

  final MessageItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: item.senderId == FirebaseAuth.instance.currentUser?.uid
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: item.senderId == FirebaseAuth.instance.currentUser?.uid
                ? 0
                : 16,
            right: item.senderId == FirebaseAuth.instance.currentUser?.uid
                ? 16
                : 0,
            top: 4,
          ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: item.text.isEmojiOnly()
                ? Colors.transparent
                : item.senderId != FirebaseAuth.instance.currentUser?.uid
                ? Color(0xFF9D5A6C)
                : Color(0xFF330057),
            borderRadius: BorderRadius.only(
              bottomLeft:
                  item.senderId != FirebaseAuth.instance.currentUser?.uid
                  ? Radius.zero
                  : Radius.circular(16),
              bottomRight:
                  item.senderId == FirebaseAuth.instance.currentUser?.uid
                  ? Radius.zero
                  : Radius.circular(16),
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                item.senderId == FirebaseAuth.instance.currentUser?.uid
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                item.text,
                style: TextStyle(
                  fontSize: item.text.isEmojiOnly() ? 45 : 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.timestamp.toString().toDateStr(pattern: "hh:mm a"),
                    style: TextStyle(
                      fontSize: 9,
                      color: item.text.isEmojiOnly()
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  if (item.senderId ==
                      FirebaseAuth.instance.currentUser?.uid) ...[
                    SizedBox(width: 4),
                    Icon(
                      (item.status == MessageStatus.sending)
                          ? Icons.history_toggle_off
                          : (item.status == MessageStatus.sent)
                          ? Icons.check
                          : (item.status == MessageStatus.delivered)
                          ? Icons.check_circle_outline
                          : Icons.check_circle,
                      size: 12,
                      color: item.text.isEmojiOnly()
                          ? Colors.black
                          : Colors.white,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
