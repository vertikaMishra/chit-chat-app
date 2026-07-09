import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whatsapp_project/modules/dashboard/dashboard_screen.dart';

class LoginController {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account == null) {
      print("No Google Account found.");
      return;
    }
    final GoogleSignInAuthentication auth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    if (userCredential.user != null && context.mounted == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    }
    else{
      print("user not found");
    }
  }
}
