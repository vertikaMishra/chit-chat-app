import 'package:firebase_database/firebase_database.dart';

class Contact {
  String image;
  String name;
  String uid;
  String? message;
  String? time;
  num? count;

  Contact({
    required this.image,
    required this.name,
    this.message,
    this.time,
    this.count,
    required this.uid,
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "image": image,
      "message": message,
      "time": time,
      "count": count,
      "uid": uid,
    };
  }

  // Convert JSON to object
  factory Contact.fromJson(DataSnapshot snapshot) {
    final json = Map<String,dynamic>.from(
      snapshot.value as Map,
    );
    return Contact(
      image: json["image"],
      name: json["name"],
      message: json["message"],
      time: json["time"],
      count: json['count'] as num?,
      uid: json['uid']?.tostring()??'',
    );
  }
}