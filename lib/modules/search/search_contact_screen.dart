import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_project/modules/search/search_contact_controller.dart';
import 'package:whatsapp_project/routes/app_screens.dart';

import '../../models/contact_item.dart';

/// Created by Vertika Mishra
///

class SearchContactScreen extends GetView<SearchContactController> {
  const SearchContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Users")),
      body: Column(
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
                      controller: controller.searchTextController,
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: InputDecoration(
                        labelText: "Search Contacts",
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
                SizedBox(width: 10),
                IconButton.filled(
                  onPressed: () {
                    if (controller.searchTextController.text
                        .trim()
                        .isNotEmpty) {
                      controller.searchContact(
                        controller.searchTextController.text.trim(),
                      );
                    }
                  },
                  icon: Icon(Icons.manage_search, size: 36),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => controller.contactList.value.when(
                none: () => SizedBox(),
                loading: () => Center(child: CircularProgressIndicator()),
                error: (msg) => Text(msg),
                success: (data) => ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return ListTile(
                      onTap: () => Get.toNamed(
                        AppScreens.chatDetails,
                        arguments: Contact(name: item.name??"", uid: item.uid??"", image:item.image??"",),
                      ),
                      title: Text(item.name ?? ""),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(item.image ?? ""),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
