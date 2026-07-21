import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_project/models/message_item.dart';
import 'package:whatsapp_project/modules/chat_details/chat_details_controller.dart';

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
        title: Text(controller.contact.name),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.call))],
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
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: InputDecoration(
                          hintText: "message here",
                          filled: true,
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          )
                      ),
                    ),
                  ),
                  SizedBox(width:8),
                  IconButton.filledTonal(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      color:Colors.white,
                      onPressed: (){}, icon:Icon(Icons.send_rounded,size: 18))
                ],
              ),
            ),
          )
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
    return Row(
      mainAxisAlignment:
          item.senderId == FirebaseAuth.instance.currentUser?.uid
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            left:
                item.senderId ==
                    FirebaseAuth.instance.currentUser?.uid
                ? 0
                : 16,
            right:
                item.senderId ==
                    FirebaseAuth.instance.currentUser?.uid
                ? 16
                : 0,
            top: 4,
          ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color:
                item.senderId !=
                    FirebaseAuth.instance.currentUser?.uid
                ? Color(0xFF9D5A6C)
                : Color(0xFF330057),
            borderRadius: BorderRadius.only(
              bottomLeft:
                  item.senderId !=
                      FirebaseAuth.instance.currentUser?.uid
                  ? Radius.zero
                  : Radius.circular(16),
              bottomRight:
                  item.senderId ==
                      FirebaseAuth.instance.currentUser?.uid
                  ? Radius.zero
                  : Radius.circular(16),
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Text(
            item.text,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
