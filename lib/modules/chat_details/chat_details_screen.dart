import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_project/models/message_item.dart';
import 'package:whatsapp_project/modules/chat_details/chat_details_controller.dart';
import 'package:whatsapp_project/widgets/emoji_full_screen_animation.dart';

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
        actions: [
          IconButton(
            onPressed: () {
              controller.clearchat();
            },
            icon: const Icon(Icons.delete_outline_outlined),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Obx(() {
                  return controller.messageList.value.when(
                    none: () => SizedBox.shrink(),
                    loading: () => Center(
                      child: CircularProgressIndicator(),
                    ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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

                      const SizedBox(width: 8),

                      IconButton.filledTonal(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        color: Colors.white,
                        onPressed: () {
                          final text =
                          controller.messageController.text.trim();

                          if (text.isNotEmpty) {
                            controller.sendMessage(text);

                            // Emoji animation
                            if (text.isEmojiOnly()) {
                              controller.showEmojiAnimation(text);
                            }
                          }

                          controller.messageController.clear();
                        },
                        icon: const Icon(
                          Icons.send_rounded,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Full-screen emoji animation
          Obx(() {
            final emoji = controller.animatedEmoji.value;

            if (emoji == null) {
              return const SizedBox.shrink();
            }

            return EmojiFullScreenAnimation(
              emoji: emoji,
              onFinished: controller.hideEmojiAnimation,
            );
          }),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.item,
  });

  final MessageItem item;

  @override
  Widget build(BuildContext context) {
    final isMe =
        item.senderId == FirebaseAuth.instance.currentUser?.uid;

    final isEmoji = item.text.isEmojiOnly();

    return Row(
      mainAxisAlignment:
      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: isMe ? 0 : 16,
            right: isMe ? 16 : 0,
            top: 4,
          ),
          padding: isEmoji
              ? const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          )
              : const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 8,
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: isEmoji
              ? null
              : BoxDecoration(
            color: isMe
                ? const Color(0xFF330057)
                : const Color(0xFF9D5A6C),
            borderRadius: BorderRadius.only(
              bottomLeft: isMe
                  ? const Radius.circular(16)
                  : Radius.zero,
              bottomRight: isMe
                  ? Radius.zero
                  : const Radius.circular(16),
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                item.text,
                style: TextStyle(
                  fontSize: isEmoji ? 55 : 18,
                  color: Colors.white,
                ),
              ),

              if (!isEmoji) ...[
                const SizedBox(height: 2),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.timestamp
                          .toString()
                          .toDateStr(pattern: "hh:mm a"),
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                      ),
                    ),

                    if (isMe) ...[
                      const SizedBox(width: 4),

                      Icon(
                        item.status == MessageStatus.sending
                            ? Icons.history_toggle_off
                            : item.status == MessageStatus.sent
                            ? Icons.check
                            : item.status == MessageStatus.delivered
                            ? Icons.check_circle_outline
                            : Icons.check_circle,
                        size: 12,
                        color: Colors.white,
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
