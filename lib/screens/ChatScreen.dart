import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/models/chat_data_participant_model.dart';
import 'package:fly_chatting_app/models/chats_check_participant_model.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/widgets/theme/colors_style.dart';
import 'package:fly_chatting_app/widgets/theme/messenger_scaffold.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController messageController = TextEditingController();

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
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chatCheck')
                  .doc(widget.chatCheck.chatId)
                  .collection('messages')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {

                    // Map chatData = snapshot.data!.docs[0].data();












                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong! Please check your internet connection.'),
                    );
                  } else {
                    return const Center(
                      child: Text('Say hii to your new friend'),
                    );
                  }
                }
                return Container();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
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
                        maxLines: 3,
                        controller: messageController,
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
                        sendMessages();
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

  Future<void> sendMessages() async {
    final String msg = messageController.text.trim();

    if (msg != '') {
      final String messageId = DateTime.now().microsecondsSinceEpoch.toString();
      ChatDataParticipant newMessage = ChatDataParticipant(
        text: msg,
        sender: widget.userModel.uid,
        seen: false,
        time: DateFormat('hh:mm a').format(DateTime.now()).toString(),
        createDone: DateTime.now(),
        messageId: messageId,
      );

      FirebaseFirestore.instance
          .collection('chatCheck')
          .doc(widget.chatCheck.chatId)
          .collection('messages')
          .doc(newMessage.messageId)
          .set(newMessage.toMap());
      log('---------------------------------------------------- message sent ----------------------------------------------------------');
    }
    messageController.clear();
  }
}
