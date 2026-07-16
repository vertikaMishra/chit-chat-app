import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_project/modules/chat_details/chat_details_controller.dart';

/// Created by Vertika Mishra

class ChatDetailsScreen extends GetView<ChatDetailsController> {
  const ChatDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC8E6C9),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: Text(controller.contact.name),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.call))],
      ),
      body: Obx(() {
        return controller.messageList.value.when(
          none: () => SizedBox.shrink(),
          loading: () => Center(child: CircularProgressIndicator()),
          error: (msg) => Text(msg),
          success: (data) => ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadiusGeometry.circular(16),
                ),
                child: Text("Message"),
              );
            },
          ),
        );
      }),
    );
  }
}
