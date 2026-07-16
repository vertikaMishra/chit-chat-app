import 'package:get/get.dart';
import 'package:whatsapp_project/core/network/ui_state.dart';
import 'package:whatsapp_project/models/message_item.dart';

import '../../models/contact_item.dart';

/// Created by Vertika Mishra

class ChatDetailsController extends GetxController {

  final Contact contact = Get.arguments;
  final messageList = Rx<UiState<List<MessageItem>>>(UiState.none());

}