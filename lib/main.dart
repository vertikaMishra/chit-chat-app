import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:whatsapp_project/firebase_options.dart';
import 'package:whatsapp_project/modules/dashboard/dashboard_screen.dart';
import 'package:whatsapp_project/modules/login/login_screen.dart';
import 'package:whatsapp_project/routes/app_routes.dart';
import 'package:whatsapp_project/routes/app_screens.dart';
import 'package:get/get.dart';
import 'package:whatsapp_project/modules/dashboard/dashboard_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late DashboardController dashboardController;
  @override
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    dashboardController = Get.put(DashboardController());

    dashboardController.updateUserStatus(true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      dashboardController.updateUserStatus(true);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      dashboardController.updateUserStatus(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Whatsapp",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          surfaceTint: Colors.white,
        ),
      ),
      getPages: appRoutes,
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? AppScreens.login
          : AppScreens.home,
    );
  }
}


