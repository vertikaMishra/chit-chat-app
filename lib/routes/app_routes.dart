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
import 'package:whatsapp_project/modules/search/search_contact_controller.dart';
import 'package:whatsapp_project/modules/search/search_contact_screen.dart';
import 'package:whatsapp_project/routes/app_screens.dart';

/// Created by Vertika Mishra

final appRoutes = [
  GetPage(
    name: AppScreens.home,
    binding: BindingsBuilder(() {
      Get.lazyPut(() {
        return ChatCantroller();
      });
      Get.lazyPut(() {
        return DashboardController();
      });
    }),
    page: () {
      return DashboardScreen();
    },
  ),
  GetPage(
    name: AppScreens.login,
    binding: BindingsBuilder(() {
      Get.lazyPut(() {
        return LoginController();
      });
    }),
    page: () {
      return LoginScreen();
    },
  ),
  GetPage(
    name: AppScreens.chatDetails,
    binding: BindingsBuilder(() {
      Get.lazyPut(() {
        return ChatDetailsController();
      });
    }),
    page: () {
      return ChatDetailsScreen();
    },
  ),GetPage(
    name: AppScreens.searchContact,
    binding: BindingsBuilder(() {
      Get.lazyPut(() {
        return SearchContactController();
      });
    }),
    page: () {
      return SearchContactScreen();
    },
  ),
];
