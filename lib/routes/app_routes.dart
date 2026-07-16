import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:whatsapp_project/modules/chat_details/chat_details_controller.dart';
import 'package:whatsapp_project/modules/chat_details/chat_details_screen.dart';
import 'package:whatsapp_project/modules/dashboard/chats/chat_cantroller.dart';
import 'package:whatsapp_project/modules/dashboard/dashboard_screen.dart';
import 'package:whatsapp_project/modules/login/login_Controller.dart';
import 'package:whatsapp_project/modules/login/login_screen.dart';
import 'package:whatsapp_project/routes/app_screens.dart';

/// Created by Vertika Mishra

final appRoutes = <String, WidgetBuilder>{
  AppScreens.home: (context) {
    Get.lazyPut(() {
      return ChatCantroller();
    });
    return DashboardScreen();
  },
  AppScreens.login: (context) {
    Get.lazyPut(() {
      return LoginController();
    });
    return LoginScreen();
  },
  AppScreens.chatDetails: (context) {
    Get.lazyPut(() {
      return ChatDetailsController();
    });
    return ChatDetailsScreen();
  },
};
