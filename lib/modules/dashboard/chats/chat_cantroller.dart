import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../models/contact_item.dart';

/// Created by Vertika Mishra

class ChatCantroller {

    Future<List<Contact>> getContactList() async {
     final DatabaseEvent event= await FirebaseDatabase.instance.ref("contacts/${FirebaseAuth.instance.currentUser!.uid}").onValue.first;

      for(final item in event.snapshot.children)
      print("=========================> ${item.value}");
     return Future.value( event.snapshot.children.map((e) =>Contact.fromJson(e)).toList());

  }



}