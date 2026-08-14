import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whatsapp_project/core/ext.dart';
import 'package:whatsapp_project/modules/dashboard/chats/chat_cantroller.dart';
import 'package:whatsapp_project/modules/login/login_screen.dart';
import 'package:whatsapp_project/routes/app_screens.dart';

import '../dashboard_screen.dart';
import '../../../models/contact_item.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends GetView<ChatCantroller> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          Get.toNamed(AppScreens.searchContact);
        },
        child: Icon(Icons.add),
        heroTag: "Button",
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 2),
          child: ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                colors: [
                  Color(0xFF00796B),
                  Color(0xFF00ACC1),
                  Color(0xFF4527A0),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds);
            },
            child: Text(
              "ChitChat",
              style: GoogleFonts.greatVibes(
                color: Colors.white,
                fontSize: 45,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 30, color: Colors.black),
            position: PopupMenuPosition.under,
            onSelected: (value) async {
              switch (value) {
                case 'Profile':
                  break;

                case 'Settings':
                  break;

                case 'Log out':
                  try {
                    await GoogleSignIn().signOut();
                    await FirebaseAuth.instance.signOut();
                    Get.offAllNamed(AppScreens.login);
                  } catch (e) {
                    debugPrint('Logout error: $e');
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<String>(
                  value: 'Profile',
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline),
                      const SizedBox(width: 12),
                      const Text('Profile'),
                    ],
                  ),
                ),

                PopupMenuItem<String>(
                  value: 'Settings',
                  child: Row(
                    children: [
                      const Icon(Icons.settings_outlined),
                      const SizedBox(width: 12),
                      const Text('Settings'),
                    ],
                  ),
                ),

                const PopupMenuDivider(),

                PopupMenuItem<String>(
                  value: 'Log out',
                  child: Row(
                    children: [
                      const Icon(Icons.logout),
                      const SizedBox(width: 12),
                      const Text('Log out'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
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
                    child:TextField(
                      controller: controller.searchController,
                      onChanged: controller.searchContacts,
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: InputDecoration(
                        labelText: "Search chats",
                        isDense: true,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(
                            Icons.search,
                            size: 25,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: controller.clearSearch,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              return controller.contactList.value.when(
                none: () => SizedBox.shrink(),
                loading: () => Center(
                  child: CircularProgressIndicator(
                    constraints: BoxConstraints(minHeight: 36, minWidth: 36),
                  ),
                ),
                error: (msg) => Text(msg),
                success: (data) {
                  return Obx(() {
                    final contacts = controller.filteredContacts;
                    return ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        Contact item = contacts[index];

                        return InkWell(
                          onTap: () {
                            Get.toNamed(
                                AppScreens.chatDetails, arguments: item);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  child: CachedNetworkImage(
                                    imageUrl: item.image ?? "",
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color(0xFF4527A0),
                                              width: 4,
                                            ),
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
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        item.name ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                      if (item.message?.isNotEmpty == true) ...[
                                        SizedBox(height: 5),
                                        Text(item.message ?? ""),
                                      ],
                                    ],
                                  ),
                                ),
                                Spacer(),
                                if (item.time?.isNotEmpty == true)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 38),
                                    child: Text(
                                      item.time.toWhatsAppDate(),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  );
                }
              );
            }),

          ),
        ],
      ),
    );
  }
}
