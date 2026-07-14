import 'package:flutter/material.dart';
import 'package:whatsapp_project/modules/dashboard/dashboard_screen.dart';
import 'package:whatsapp_project/modules/login/login_screen.dart';
import 'package:whatsapp_project/routes/app_screens.dart';

/// Created by Vertika Mishra

final appRoutes = <String,WidgetBuilder>{

        AppScreens.home:(context){
            return DashboardScreen();
  },
        AppScreens.login:(context){
          return LoginScreen();
  }
  
};