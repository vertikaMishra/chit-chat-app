import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_project/calls_screen.dart';
import 'package:whatsapp_project/communities_screen.dart';
import 'package:whatsapp_project/updates_screen.dart';

import 'home_screen.dart';

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
}

class MainScreen extends StatelessWidget{
  MainScreen({super.key});

  List<Contact> contactList = [
    Contact(
      image:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQt__mXLv_T7qPP0p-gfXzpb6yDcE3s4ZVckiMlbINhNKzwd5v5P_aOF4&s=10",
      name: "Vartika",
      message: "hey whats up!!",
      time: "12:45pm",
    ),
    Contact(
      image:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3Q-OLndLC3Aj208pseNRiOZqwblD2xcHbKzVgBYZk3Q&s=10",
      name: "Amrita",
      message: "we will meet tomorrow",
      time: "11:48am",
    ),
    Contact(
      image:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYAf6BuPm0XMnrN2ib9O3EfgK0OL1m3DprwIkiJSGw5A&s=10",
      name: "Alia",
      message: "Hello..",
      time: "10:34am",
    ),
    Contact(
      image:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSXR98UtJKpUhCGMAEIj_6iWD5lyPNuvIa9E97kX5D7Q&s=10",
      name: "John",
      message: "hey dude!!",
      time: "8:39am",
    ),
    Contact(
      image:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpjZRTUmg-B0GdfcBl0NLCX83BbiNU0C8ja6fXaFGHKA&s",
      name: "Deepika",
      message: "kal milte hai..",
      time: "yesterday",
    ),
    Contact(
      image:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiXC5EdCVMgrhccGqfpyT-9UChayQBUUDEa6-ranvf_Q&s",
      name: "Anshika",
      message: "Good night dear..",
      time: "yesterday",
    ),
    Contact(
      image:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBvq26wOg0Zi4H-gLYQKJsHN1IhEoteb3j2cn9u__ifA&s=10",
      name: "Nick",
      message: "Good Morning!!",
      time: "yesterday",
    ),
    Contact(
      image:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAYHJ7McfDsxFcBpO6-yuZ7pDUfnYgEGGWpNPuOFxAFw&s=10",
      name: "Avantika",
      message: "good evening..",
      time: "12/06/26",
    ),
    Contact(
      image:
      "https://img.magnific.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg?semt=ais_hybrid&w=740&q=80",
      name: "Robert",
      message: "Good Morning!!",
      time: "11/06/26",
    ),
    Contact(
      image:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiXC5EdCVMgrhccGqfpyT-9UChayQBUUDEa6-ranvf_Q&s",
      name: "Anshika",
      message: "Good Morning",
      time: "08/06/26",
    ),
    Contact(
      image:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiXC5EdCVMgrhccGqfpyT-9UChayQBUUDEa6-ranvf_Q&s",
      name: "Anshika",
      message: "Good Morning",
      time: "08/06/26",
    ),
    Contact(
      image:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiXC5EdCVMgrhccGqfpyT-9UChayQBUUDEa6-ranvf_Q&s",
      name: "Anshika",
      message: "Good Morning",
      time: "08/06/26",
    ),
    Contact(
      image:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiXC5EdCVMgrhccGqfpyT-9UChayQBUUDEa6-ranvf_Q&s",
      name: "Anshika",
      message: "Good Morning",
      time: "08/06/26",
    ),
    Contact(
      image:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiXC5EdCVMgrhccGqfpyT-9UChayQBUUDEa6-ranvf_Q&s",
      name: "Anshika",
      message: "Good Morning",
      time: "08/06/26",
    ),
    Contact(
      image:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiXC5EdCVMgrhccGqfpyT-9UChayQBUUDEa6-ranvf_Q&s",
      name: "Anshika",
      message: "Good Morning",
      time: "08/06/26",
    ),
    Contact(
      image:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiXC5EdCVMgrhccGqfpyT-9UChayQBUUDEa6-ranvf_Q&s",
      name: "Anshika",
      message: "Good Morning",
      time: "08/06/26",
    ),
  ];
  final currentIndex = ValueNotifier(0);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:ValueListenableBuilder(
        valueListenable: currentIndex,
        builder: (context, value, child) {
          return IndexedStack(
            index:value,
            children: [
            HomeScreen(contactList: contactList),
            UpdatesScreen(),
            CommunitiesScreen(),
            CallsScreen(),
          ],);
        }
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: currentIndex,
        builder: (context, value, child) {
          return BottomNavigationBar(
            currentIndex:value,
            unselectedItemColor: Colors.black,
            selectedItemColor: Colors.black,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            onTap: (value) {
            currentIndex.value=value;
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.message_outlined,size:30),
                  label: "Chats",
                  activeIcon: Icon(Icons.message, color: Colors.green)),
              BottomNavigationBarItem(
                icon: Icon(Icons.donut_large_outlined,size: 30),
                label: "Updates",
                activeIcon: Icon(Icons.donut_large, color: Colors.green),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.groups_outlined,size:30),
                label: "Communities",
                activeIcon: Icon(Icons.groups, color: Colors.green),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.call_outlined,size:30,),
                label: "Calls",
                activeIcon: Icon(Icons.call, color: Colors.green),
              ),
            ],
          );
        }
      ),
    );
  }
}
