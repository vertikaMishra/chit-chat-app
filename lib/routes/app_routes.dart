import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:whatsapp_project/modules/chat_details/chat_details_controller.dart';
import 'package:whatsapp_project/modules/chat_details/chat_details_screen.dart';
import 'package:whatsapp_project/modules/dashboard/chats/chat_cantroller.dart';
import 'package:whatsapp_project/modules/dashboard/dashboard_controller.dart';
import 'package:whatsapp_project/modules/dashboard/dashboard_screen.dart';
import 'package:whatsapp_project/modules/login/login_Controller.dart';
import 'package:whatsapp_project/modules/login/login_screen.dart';
import 'package:whatsapp_project/routes/app_screens.dart';

/// Created by Vertika Mishra

final appRoutes = [
  GetPage(
    name: AppScreens.home,
    page: () {
      Get.lazyPut(() {
        return ChatCantroller();
      });
      Get.lazyPut(() {
        return DashboardController();
      });
      return DashboardScreen();
    },
  ),
  GetPage(
    name: AppScreens.login,
    page: () {
      Get.lazyPut(() {
        return LoginController();
      });
      return LoginScreen();
    },
  ),
  GetPage(
    name: AppScreens.chatDetails,
    page: () {
      Get.lazyPut(() {
        return ChatDetailsController();
      });
      return ChatDetailsScreen();
    },
  ),
];
