import 'dart:developer';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/models/chats_check_participant_model.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/widgets/theme/colors_style.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.userModel,
    required this.firebaseUser,
    required this.targetUser,
    required this.chatCheck,
    this.contactName,
    this.contactNumbers,
    this.contactImages,
    this.contactNameFirst,
  });

  final User firebaseUser;
  final UserModel userModel;
  final UserModel targetUser;
  final ChatCheckParticipant chatCheck;
  final String? contactName;
  final String? contactNumbers;
  final Uint8List? contactImages;
  final String? contactNameFirst;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.arrow_back,
            size: 28,
          ),
        ),
        title: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          child: ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blueGrey.shade50,
              backgroundImage:
                  NetworkImage(widget.targetUser.profilePicture.toString()),
            ),
            contentPadding: EdgeInsets.zero,
            title: Text(
              widget.targetUser.fullName.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Image(
              image: AssetImage('assets/icons/menu-vertical.png'),
              height: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: lightBlueColor,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        minLines: 1,
                        controller: chatController,
                        decoration: InputDecoration(
                          hintText: 'Message',
                          contentPadding: const EdgeInsets.only(
                            right: 15,
                            left: 25,
                            bottom: 15,
                            top: 15,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () async {
                        log('--------------local-------------------${widget.contactNumbers}-----------------------------------------');
                      },
                      child: CircleAvatar(
                        backgroundColor: lightBlueColor,
                        radius: 27,
                        child: Container(
                          padding: const EdgeInsets.only(left: 5),
                          child: const Icon(
                            Icons.send_rounded,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
