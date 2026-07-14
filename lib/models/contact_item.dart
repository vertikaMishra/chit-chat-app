import 'package:firebase_database/firebase_database.dart';

class Contact {
  String image;
  String name;
  String message;
  String time;

  Contact({
    required this.image,
    required this.name,
    required this.message,
    required this.time,
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "image": image,
      "message": message,
      "time": time,
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
    );
  }
}