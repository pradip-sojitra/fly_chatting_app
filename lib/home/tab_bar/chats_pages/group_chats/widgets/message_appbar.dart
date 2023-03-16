// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/home/tab_bar/calls_pages/provider/calls_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/group_chats/provider/group_chat_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/provider/chat_provider.dart';
import 'package:fly_chatting_app/models/message_model.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:provider/provider.dart';

class MessageAppBar extends StatelessWidget with PreferredSizeWidget {
  String receiverId;
  bool isGroupChat;
  String photo;
  String name;

  MessageAppBar(
      {Key? key,
      required this.photo,
      required this.name,
      required this.isGroupChat,
      required this.receiverId})
      : super(key: key);

  String lastSeenMessage(lastSeen) {
    final difference = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(lastSeen));

    final String finalSeen = difference.inSeconds > 59
        ? difference.inMinutes > 59
            ? difference.inHours > 24
                ? difference.inDays > 23
                    ? "${difference.inHours} ${difference.inHours == 1 ? "hour" : "hours"}"
                    : "${difference.inDays} ${difference.inDays == 1 ? "day" : "days"}"
                : "${difference.inHours} ${difference.inHours == 1 ? "hour" : "hours"}"
            : "${difference.inMinutes} ${difference.inMinutes == 1 ? "minute" : "minutes"}"
        : "few moments";
    return finalSeen;
  }

  @override
  Widget build(BuildContext context) {
    return context.watch<GroupChatProvider>().selectedMessagesId.isEmpty
        ? AppBar(
            automaticallyImplyLeading: false,
            title: isGroupChat
                ? ListTile(
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
                          backgroundImage: NetworkImage(photo),
                        ),
                      ],
                    ),
                    contentPadding: EdgeInsets.zero,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: "Rounded Bold"),
                        ),
                      ],
                    ),
                  )
                : StreamBuilder<UserModel>(
                    stream:
                        context.watch<ChatProvider>().fireUserData(receiverId),
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: "Rounded Bold"),
                            ),
                            Text(
                              snapshot.data!.active == true
                                  ? 'online'
                                  : "${lastSeenMessage(snapshot.data!.isSeen)} ago",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: "Rounded Bold"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            actions: [
              StreamBuilder(
                  stream:
                      context.watch<ChatProvider>().fireUserData(receiverId),
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
                            .userData(
                                uid: FirebaseAuth.instance.currentUser!.uid);

                        context.read<CallProvider>().dial(
                            sender: senderData!,
                            receiver: receiverData,
                            context: context);
                      },
                      icon: const Icon(Icons.videocam_rounded),
                      iconSize: 26,
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
          )
        : AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 18),
              child: IconButton(
                onPressed: () {
                  context.read<GroupChatProvider>().selectMessageClear();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(context
                .read<GroupChatProvider>()
                .selectedMessagesId
                .length
                .toString()),
            actions: [
              if (context.read<GroupChatProvider>().selectedMessagesId.length <=
                  1)
                IconButton(
                  onPressed: () {},
                  icon: const RotatedBox(
                      quarterTurns: 90, child: Icon(Icons.forward_rounded)),
                  iconSize: 28,
                ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.star_rounded),
                iconSize: 28,
              ),
              IconButton(
                onPressed: () async {
                  var fireStore = FirebaseFirestore.instance;
                  var auth = FirebaseAuth.instance;

                  for (var messageData
                      in context.read<GroupChatProvider>().selectedMessagesId) {
                    if (isGroupChat) {
                      await fireStore
                          .collection("groups")
                          .doc(receiverId)
                          .collection("chats")
                          .doc(messageData)
                          .delete();
                    } else {
                      fireStore
                          .collection("users")
                          .doc(auth.currentUser!.uid)
                          .collection("chats")
                          .doc(receiverId)
                          .collection("messages")
                          .doc(messageData)
                          .delete();
                    }
                  }

                  context.read<GroupChatProvider>().selectMessageClear();
                },
                icon: const Icon(Icons.delete),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.copy_rounded),
                iconSize: 26,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.forward_rounded),
                iconSize: 30,
              ),
              const SizedBox(width: 10),
            ],
          );
  }

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);
}
