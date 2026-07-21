import 'package:get/get.dart';
import 'package:whatsapp_project/core/network/ui_state.dart';
import 'package:whatsapp_project/models/message_item.dart';

import '../../models/contact_item.dart';

/// Created by Vertika Mishra

class ChatDetailsController extends GetxController {
  final Contact contact = Get.arguments;
  final messageList = Rx<UiState<List<MessageItem>>>(UiState.none());

  @override
  void onReady() {
    getMessages();
    super.onReady();
  }

  void getMessages() {
    messageList.value = UiState.success([
      MessageItem(
        conversationId: "conversationId",
        msgId: "msgId",
        senderId: "senderId",
        text: "Hello Dart",
        type: MessageType.text,
        timestamp: 355584095098,
        status: MessageStatus.read,
      ),
      MessageItem(
        conversationId: "conversationId",
        msgId: "msgId",
        senderId: "0133s2OCZ9WeABv0L3iSw3PyGWq1",
        text: "hey buddy",
        type: MessageType.text,
        timestamp: 355584095098,
        status: MessageStatus.read,
      ),MessageItem(
        conversationId: "conversationId",
        msgId: "msgId",
        senderId: "senderId",
        text: "yes",
        type: MessageType.text,
        timestamp: 355584095098,
        status: MessageStatus.read,
      ),MessageItem(
        conversationId: "conversationId",
        msgId: "msgId",
        senderId: "0133s2OCZ9WeABv0L3iSw3PyGWq1",
        text: "how are you!!",
        type: MessageType.text,
        timestamp: 355584095098,
        status: MessageStatus.read,
      ),MessageItem(
        conversationId: "conversationId",
        msgId: "msgId",
        senderId: "senderId",
        text: "hmm",
        type: MessageType.text,
        timestamp: 355584095098,
        status: MessageStatus.read,
      ),MessageItem(
        conversationId: "conversationId",
        msgId: "msgId",
        senderId: "0133s2OCZ9WeABv0L3iSw3PyGWq1",
        text: "I am in summer training right now!! what's about you?? ",
        type: MessageType.text,
        timestamp: 355584095098,
        status: MessageStatus.read,
      ),MessageItem(
        conversationId: "conversationId",
        msgId: "msgId",
        senderId: "senderId",
        text: "I am fine also",
        type: MessageType.text,
        timestamp: 355584095098,
        status: MessageStatus.read,
      ),
    ]);
  }
}
