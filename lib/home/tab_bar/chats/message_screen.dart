import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fly_chatting_app/home/tab_bar/chats/widgets/bottom_text_field.dart';
import 'package:fly_chatting_app/models/message_model.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/providers/chat_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({
    super.key,
    required this.receiverId,
  });

  final String receiverId;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    log('Build_MessageScreen');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: StreamBuilder<UserModel>(
            stream: context.watch<ChatProvider>().userData(widget.receiverId),
            builder: (context, AsyncSnapshot<UserModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }
              return ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                    CircleAvatar(
                      radius: 22.5,
                      backgroundColor: Colors.blueGrey.shade50,
                      backgroundImage:
                          NetworkImage(snapshot.data!.profilePicture!),
                    ),
                  ],
                ),
                contentPadding: EdgeInsets.zero,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.data!.fullName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: "Rounded Bold"),
                    ),
                    Text(
                      snapshot.data!.isOnline == true ? 'online' : 'offline',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          fontFamily: "Rounded Bold"),
                    ),
                  ],
                ),
              );
            }),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .collection('chats')
                    .doc(widget.receiverId)
                    .collection('messages')
                    .orderBy('time', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    scrollController
                        .jumpTo(scrollController.position.maxScrollExtent);
                  });

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      MessageModel messages = MessageModel.fromJson(
                          snapshot.data!.docs[index].data());
                      bool checkData = messages.senderId ==
                          FirebaseAuth.instance.currentUser!.uid;
                      return Align(
                        alignment:
                            checkData ? Alignment.topRight : Alignment.topLeft,
                        child: Padding(
                          padding: checkData
                              ? const EdgeInsets.only(left: 50)
                              : const EdgeInsets.only(right: 50),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            splashColor: Colors.blue,
                            onLongPress: () async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser?.uid)
                                  .collection('chats')
                                  .doc(widget.receiverId)
                                  .collection('messages')
                                  .doc(messages.messageId)
                                  .delete();
                            },
                            child: Card(
                              elevation: 3.5,
                              color: checkData
                                  ? Colors.blue.shade100
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: checkData
                                    ? const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                      )
                                    : const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 10),
                                    child: Wrap(
                                      alignment: WrapAlignment.end,
                                      children: [
                                        Text(
                                          messages.text,
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
                                              DateFormat.jm().format(
                                                  messages.time.toDate()),
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 6, right: 6, left: 6),
              child: BottomTextField(receiverId: widget.receiverId)),
        ],
      ),
    );
  }
}
