import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whatsapp_project/modules/dashboard/dashboard_screen.dart';
import 'package:whatsapp_project/routes/app_screens.dart';

class LoginController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final isLoading = false.obs;

  Future<void> signInWithGoogle(BuildContext context) async {
    isLoading.value = true;
    UserCredential? userCredential;
    userCredential = await signInWithGoogleForWeb();
    if (userCredential == null) {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        print("No Google Account found.");
        isLoading.value=false;
        return;
      }
      final GoogleSignInAuthentication auth = await account.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
    }

    if (userCredential.user != null && context.mounted == true) {
      final userData = await FirebaseDatabase.instance
          .ref('users')
          .child(userCredential.user!.uid)
          .once();
      if (userData.snapshot.value == null) {
        await FirebaseDatabase.instance
            .ref('users')
            .child(userCredential.user!.uid)
            .set({
              "name": userCredential.user!.displayName,
              "email": userCredential.user!.email,
              "image": userCredential.user!.photoURL,
              "uid": userCredential.user!.uid,
              "userName":
                  (userCredential.user!.email?.split("@")[0] ?? "")
                      .toLowerCase() +
                  generateCode(),
              "bio": "",
            });
      }
      isLoading.value=false;
      if (context.mounted == true) {
        Get.offAllNamed(AppScreens.home);
      }
    } else {
      print("user not found");
    }
    isLoading.value=false;
  }

  Future<UserCredential?> signInWithGoogleForWeb() async {
    try {
      if (kIsWeb) {
        final GoogleAuthProvider provider = GoogleAuthProvider();
        provider.setCustomParameters({'prompt': 'select_account'});
        final UserCredential result = await _auth.signInWithPopup(provider);
        debugPrint('Firebase user: ${result.user?.email}');
        return result;
      }
      return null;
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('Firebase Auth error: ${e.code}');
      debugPrint('Firebase Auth message: ${e.message}');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('Google sign-in error: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  String generateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(
      4,
      (_) => chars[random.nextInt(chars.length)],
    ).join().toLowerCase();
  }
}
