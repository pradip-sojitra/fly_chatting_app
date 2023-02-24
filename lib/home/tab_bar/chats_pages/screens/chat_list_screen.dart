import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/common/widgets/theme/colors_style.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/screens/contact_chat_screen.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/screens/message_screen.dart';
import 'package:fly_chatting_app/models/chat_list_model.dart';
import 'package:intl/intl.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('chats')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.separated(
                itemCount: snap.data!.docs.length,
                itemBuilder: (context, index) {
                  ChatListModel user =
                      ChatListModel.fromJson(snap.data!.docs[index].data());
                  return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  MessageScreen(receiverId: user.id),
                            ));
                          },
                          leading: CupertinoButton(
                            onPressed: () {
                              showProfilePicture(user);
                            },
                            padding: EdgeInsets.zero,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                    radius: 26,
                                    backgroundColor: Colors.blueGrey.shade50,
                                    backgroundImage: user.profilePic.isEmpty
                                        ? null
                                        : NetworkImage(user.profilePic),
                                    child: user.profilePic.isEmpty
                                        ? const Image(
                                            image: AssetImage(
                                                'assets/icons/person_2.png'),
                                            height: 38,
                                            color: Color(0xffadb5bd),
                                          )
                                        : null),
                                Positioned(
                                  bottom: 1,
                                  right: 1,
                                  child: CircleAvatar(
                                    radius: 6,
                                    backgroundColor: snapshot.data!
                                            .data()!['isOnline']
                                        ? Colors.green
                                        : Colors.grey.shade400.withOpacity(.94),
                                  ),
                                )
                              ],
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                      fontFamily: 'Rounded ExtraBold',
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    DateFormat.jm().format(user.time.toDate()),
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.5,
                                        fontFamily: 'Varela Round Regular'),
                                  ),
                                ],
                              ),
                              Text(
                                user.lastMessage,
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'Varela Round Regular'),
                              ),
                            ],
                          ),
                        );
                      });
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 6,
                    color: Color(0x0F7ca6fe),
                    thickness: 6,
                    indent: 32,
                    endIndent: 0,
                  );
                });
          }),

    );
  }

  void showProfilePicture(ChatListModel chatList) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height: 280,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(chatList.profilePic),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.20),
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        chatList.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(
                      Icons.chat,
                      size: 28,
                      color: AppColors.darkBlueColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return MessageScreen(
                            receiverId: chatList.id,
                          );
                        },
                      ));
                    },
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(
                      Icons.call,
                      size: 28,
                      color: AppColors.darkBlueColor,
                    ),
                    onPressed: () {},
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(
                      Icons.videocam_rounded,
                      size: 28,
                      color: AppColors.darkBlueColor,
                    ),
                    onPressed: () {},
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(
                      Icons.error_outline,
                      size: 28,
                      color: AppColors.darkBlueColor,
                    ),
                    onPressed: () {},
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
