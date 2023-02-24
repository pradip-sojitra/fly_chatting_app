// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fly_chatting_app/home/tab_bar/calls_pages/provider/calls_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/calls_pages/screens/pickup/pickup_layout.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/widgets/Display_text_image_video_gif.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/widgets/bottom_text_field.dart';
import 'package:fly_chatting_app/models/message_enum.dart';
import 'package:fly_chatting_app/models/message_model.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/provider/chat_&_message_provider.dart';
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
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('Build_MessageScreen');
    return PickupLayoutScreen(
      scaffold: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: StreamBuilder<UserModel>(
              stream:
                  context.watch<ChatProvider>().fireUserData(widget.receiverId),
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
            StreamBuilder(
                stream:
                    context.watch<ChatProvider>().fireUserData(widget.receiverId),
                builder: (context, snapshot) {
                  return IconButton(
                    onPressed: () async {
                      UserModel receiverData = UserModel(
                        phoneNumber: snapshot.data!.phoneNumber,
                        uid: snapshot.data!.uid,
                        fullName: snapshot.data!.fullName,
                        profilePicture: snapshot.data!.profilePicture,
                      );

                      var senderData = await context
                          .read<ChatProvider>()
                          .userData(uid: FirebaseAuth.instance.currentUser!.uid);

                      context.read<CallProvider>().dial(
                          sender: senderData!,
                          receiver: receiverData,
                          context: context);
                    },
                    icon: const Icon(Icons.video_call),
                  );
                }),
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
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      scrollController.animateTo(
                          scrollController.position.minScrollExtent,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut);
                    });

                    return ListView.builder(
                      controller: scrollController,
                      reverse: true,
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
                                ? const EdgeInsets.only(left: 50, top: 2)
                                : const EdgeInsets.only(right: 50, top: 2),
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
                                elevation: 3.6,
                                color: checkData
                                    ? Colors.grey.shade300
                                    : Colors.white,
                                shape: messages.type == MessageEnum.text
                                    ? RoundedRectangleBorder(
                                        borderRadius: checkData
                                            ? const BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              )
                                            : const BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                              ),
                                      )
                                    : const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14))),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: messages.type == MessageEnum.text
                                          ? const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 10)
                                          : const EdgeInsets.all(6),
                                      child: Wrap(
                                        alignment: WrapAlignment.end,
                                        children: [
                                          DisplayTextImageGIF(messages: messages),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            children: [
                                              if (messages.type ==
                                                  MessageEnum.text)
                                                const SizedBox(height: 10),
                                              if (messages.type ==
                                                  MessageEnum.text)
                                                Text(
                                                  DateFormat.jm().format(
                                                      messages.time.toDate()),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey.shade500,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                              const SizedBox(width: 10),
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
      ),
    );
  }
}
