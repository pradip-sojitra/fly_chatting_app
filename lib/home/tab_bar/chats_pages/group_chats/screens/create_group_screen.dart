import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/common/utils.dart';
import 'package:fly_chatting_app/common/widgets/theme/colors_style.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/group_chats/provider/group_chat_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/group_chats/screens/select_contacts_group.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  File? image;
  TextEditingController groupNameController = TextEditingController();

  selectImage() async {
    image = await selectedImage(context, ImageSource.gallery);
    setState(() {});
  }

  void createGroup() {
    if (groupNameController.text.trim().isNotEmpty && image != null) {
      context.read<GroupChatProvider>().createGroup(
            context: context,
            groupName: groupNameController.text.trim(),
            groupImage: image!,
          );
    }
    Navigator.pop(context);
    context.read<GroupChatProvider>().selectedContacts.clear();
  }

  @override
  Widget build(BuildContext context) {
    print('Build group list');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Group',
          style: TextStyle(
              fontFamily: 'Rounded Bold', fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Stack(
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundColor: AppColors.lightDimBlueColor,
                  backgroundImage: image != null ? FileImage(image!) : null,
                  child: image == null
                      ? Image(
                          image: const AssetImage('assets/icons/person_2.png'),
                          color: Colors.grey.shade100,
                        )
                      : null,
                ),
                Positioned(
                  bottom: -5,
                  right: -5,
                  child: CupertinoButton(
                    onPressed: selectImage,
                    child: const CircleAvatar(
                      radius: 20,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: groupNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter Group Name',
                  hintStyle: TextStyle(fontFamily: 'Varela Round Regular'),
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(top: 10, bottom: 6),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Select Contacts',
                  style: TextStyle(
                    fontFamily: 'Rounded Black',
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            const SelectContactGroupScreen()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        child: const Icon(Icons.done, size: 26),
      ),
    );
  }
}
