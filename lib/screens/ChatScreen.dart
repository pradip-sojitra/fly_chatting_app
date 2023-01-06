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
  final ChatCheckModel chatCheck;
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
                  .orderBy('messageId', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        ChatDataModel currentMessage = ChatDataModel.fromMap(
                            snapshot.data!.docs[index].data());
                        final bool isUserCheck =
                            currentMessage.sender == widget.userModel.uid;
                        return Align(
                          alignment: isUserCheck
                              ? Alignment.topRight
                              : Alignment.topLeft,
                          child: Padding(
                            padding: isUserCheck
                                ? const EdgeInsets.only(left: 50)
                                : const EdgeInsets.only(right: 50),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              splashColor: AppColors.lightBlueColor,
                              onLongPress: () {
                                messageDelete(currentMessage);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.lightFullBlueColor,
                                    borderRadius: isUserCheck
                                        ? const BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                            bottomLeft: Radius.circular(8))
                                        : const BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                            bottomRight: Radius.circular(8))),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 12),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      alignment: WrapAlignment.end,
                                      children: [
                                        Text(
                                          currentMessage.text.toString(),
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          children: [
                                            const SizedBox(height: 12),
                                            Text(
                                              currentMessage.time.toString(),
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                          'Something went wrong! Please check your internet connection.'),
                    );
                  } else {
                    return const Center(
                      child: Text('Say hii to your new friend'),
                    );
                  }
                }
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
                    color: AppColors.lightBlueColor,
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
                        backgroundColor: AppColors.lightBlueColor,
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
      ChatDataModel newMessage = ChatDataModel(
        text: msg,
        sender: widget.userModel.uid,
        time: DateFormat('hh:mm a').format(DateTime.now()).toString(),
        messageId: messageId,
      );

      FirebaseFirestore.instance
          .collection('chatCheck')
          .doc(widget.chatCheck.chatId)
          .collection('messages')
          .doc(newMessage.messageId)
          .set(newMessage.toMap());
      log('---------------------------------------------------- message sent ----------------------------------------------------------');

      setState(() {
        widget.chatCheck.lastMessage = msg;
        widget.chatCheck.lastTime = newMessage.time;
      });

      FirebaseFirestore.instance
          .collection('chatCheck')
          .doc(widget.chatCheck.chatId)
          .set(widget.chatCheck.toMap());
    }
    messageController.clear();
  }

  Future<void> messageDelete(ChatDataModel currentMessage) async {
    await FirebaseFirestore.instance
        .collection('chatCheck')
        .doc(widget.chatCheck.chatId)
        .collection('messages')
        .doc(currentMessage.messageId)
        .delete();
  }
}
