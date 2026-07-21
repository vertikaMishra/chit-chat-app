import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_project/modules/dashboard/dashboard_controller.dart';

class ProfileScreen extends GetView<DashboardController>{
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 130),
              child: Badge(
                padding: EdgeInsets.all(5),
                alignment: Alignment.bottomRight,
                label: Icon(Icons.edit, color: Colors.white, size: 40),
                offset: Offset(-45, -45),
                backgroundColor: Colors.amber,
                child: CircleAvatar(
                  radius: 130,
                  backgroundImage: NetworkImage(
                    FirebaseAuth.instance.currentUser?.photoURL ?? "",
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Text(
            FirebaseAuth.instance.currentUser?.displayName ?? "",
            style: TextStyle(fontSize: 35),
          ),
          Text(
            FirebaseAuth.instance.currentUser?.email ?? "",
            style: TextStyle(fontSize: 16),
          ),

          SizedBox(height: 25),
          buildProfileTile(
            title: "Edit profile",
            subtitle: "Edit and update profile updates",
            icon: Icons.navigate_next,
            onTap: () => showUpdateProfileSheet(),
          ),
          buildProfileTile(
            title: "Settings",
            subtitle: "Change you want",
            icon: Icons.settings,
          ),
          buildProfileTile(
            title: "Invite",
            subtitle: "Invite your favourites",
            icon: Icons.insert_invitation_outlined,
          ),
          buildProfileTile(
            title: "LogOut",
            subtitle: "Anytime",
            icon: Icons.login_outlined,
          ),
        ],
      ),
    );
  }

  Padding buildProfileTile({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: ListTile(
        minVerticalPadding: 22,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Colors.amber,
        leading: Icon(icon),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.navigate_next),
      ),
    );
  }

  void showUpdateProfileSheet() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(
      text: FirebaseAuth.instance.currentUser?.displayName,
    );

    final bioController = TextEditingController(text: "");

    Get.bottomSheet(
      SafeArea(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(Get.context!).size.height * .7,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
          ),
          child: Column(
            children: [
              Text("Edit profile", style: TextStyle(fontSize: 25)),
              Divider(),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Form(
                    key:formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        TextFormField(
                          controller:nameController,
                          decoration: InputDecoration(
                            labelText: "Name",
                            hintText: "Enter name",
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          validator:(value) => (value?.trim().length ?? 0) >=3?null
                              :"please enter a valid name",
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: TextEditingController(
                            text: FirebaseAuth.instance.currentUser?.email,
                          ),
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: "E-mail",
                            hintText: "Enter your e-mail",
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller:bioController,
                          decoration: InputDecoration(
                            labelText: "Bio",
                            hintText: "Enter Bio...",
                            isDense: true,
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          minLines: 2,
                          maxLines: 3,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()){
                              controller.updateProfile(
                                name: nameController.text,
                                bio: bioController.text,
                              );
                            }
                          },
                          child: Text("update", style: TextStyle(fontSize: 22)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
