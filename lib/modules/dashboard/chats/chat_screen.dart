import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_project/modules/dashboard/chats/chat_cantroller.dart';

import '../dashboard_screen.dart';
import '../../../models/contact_item.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({
    super.key,
  });
  
  final chatCantroller = ChatCantroller();


  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            "ChitChat",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w800,
              fontSize: 25,
            ),
          ),
        ),
        actions: [
          CircleAvatar(
            radius: 13,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Center(
                child: Icon(
                  Icons.currency_rupee,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(width: 30),
          Icon(
            Icons.camera_alt_outlined,
            size: 30,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          SizedBox(width: 30),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              Icons.more_vert,
              size: 30,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body:  Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 12, 5),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(500),
                    ),
                    color: Colors.white70,
                    elevation: 0.1,
                    child: TextField(
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: InputDecoration(
                        labelText: "Ask Meta AI or Search",
                        isDense: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Icon(Icons.search, size: 25),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 2),
            child: SingleChildScrollView(
              scrollDirection:Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 25),
                  ChoiceChip.elevated(
                    label: Text(
                      "All",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    selected: true,
                    showCheckmark: false,
                    selectedColor: Colors.white70,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(100),
                      side: BorderSide(width: 1.5, color: Colors.black12),
                    ),
                  ),
                  SizedBox(width: 10),
                  ChoiceChip.elevated(
                    label: Text(
                      "Unread",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    selected: true,
                    showCheckmark: false,
                    selectedColor: Colors.white70,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(100),
                      side: BorderSide(width: 1.5, color: Colors.black12),
                    ),
                  ),
                  SizedBox(width: 10),
                  ChoiceChip.elevated(
                    label: Text(
                      "Favourites",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    selected: true,
                    showCheckmark: false,
                    selectedColor: Colors.white70,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(100),
                      side: BorderSide(width: 1.5, color: Colors.black12),
                    ),
                  ),
                  SizedBox(width: 10),
                  ChoiceChip.elevated(
                    label: Text(
                      "Groups",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    selected: true,
                    showCheckmark: false,
                    selectedColor: Colors.white70,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(100),
                      side: BorderSide(width: 1.5, color: Colors.black12),
                    ),
                  ),
                  SizedBox(width: 10),
                  ChoiceChip.elevated(
                    label: Text(
                      "+",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    selected: true,
                    showCheckmark: false,
                    selectedColor: Colors.white70,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(100),
                      side: BorderSide(width: 1.5, color: Colors.black12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: chatCantroller.getContactList(),
              builder: (context, asyncSnapshot) {
                if(asyncSnapshot.connectionState==ConnectionState.waiting){
                  return CircularProgressIndicator();
                }
                final data = asyncSnapshot.data??[];
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    Contact item = data[index];
                
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            child: CachedNetworkImage(
                              imageUrl: item.image,
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green, width: 4),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 5),
                                Text(item.message),
                              ],
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 38),
                            child: Text(item.time, style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
