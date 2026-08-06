/// Created by Vertika Mishra

import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? name;
  String? email;
  String? image;
  String? uid;
  String? userName;
  String? bio;
  bool? online;
  int? lastSeen;

  UserModel({
    this.name,
    this.email,
    this.image,
    this.uid,
    this.userName,
    this.bio,
    this.online,
    this.lastSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "image": image,
      "uid": uid,
      "userName": userName,
      "bio": bio,
      "online": online,
      "lastSeen": lastSeen,
    };
  }

  factory UserModel.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>?;

    return UserModel(
      name: data?["name"]?.toString(),
      email: data?["email"]?.toString(),
      image: data?["image"]?.toString(),
      uid: data?["uid"]?.toString(),
      userName: data?["userName"]?.toString(),
      bio: data?["bio"]?.toString(),
      online: data?["online"] ?? false,
      lastSeen: data?["lastSeen"],
    );
  }

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      name: map["name"]?.toString(),
      email: map["email"]?.toString(),
      image: map["image"]?.toString(),
      uid: map["uid"]?.toString(),
      userName: map["userName"]?.toString(),
      bio: map["bio"]?.toString(),
      online: map["online"] ?? false,
      lastSeen: map["lastSeen"],
    );
  }
}