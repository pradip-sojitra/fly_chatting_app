import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/group_chats/provider/group_chat_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/screens/message_screen.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/utils/show_profile.dart';
import 'package:fly_chatting_app/models/chat_list_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: context.read<GroupChatProvider>().getChatGroups(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snap.data!.length,
                  itemBuilder: (context, index) {
                    var user = snap.data![index];
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MessageScreen(
                              receiverId: user.groupId,
                              isGroupChat: true,
                              name: user.groupName,
                              photo: user.groupProfilePic,
                            ),
                          ),
                        );
                      },
                      leading: CupertinoButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.blueGrey.shade50,
                            backgroundImage: user.groupProfilePic.isEmpty
                                ? null
                                : NetworkImage(user.groupProfilePic),
                            child: user.groupProfilePic.isEmpty
                                ? const Image(
                                    image:
                                        AssetImage('assets/icons/person_2.png'),
                                    height: 38,
                                    color: Color(0xffadb5bd),
                                  )
                                : null),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                user.groupName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Rounded ExtraBold',
                                ),
                              ),
                              const Spacer(),
                              Text(
                                DateFormat.jm().format(user.time),
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                fontFamily: 'Varela Round Regular'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            StreamBuilder(
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
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MessageScreen(
                                  receiverId: user.id,
                                  isGroupChat: false,
                                  name: user.name,
                                  photo: user.profilePic,
                                ),
                              ),
                            );
                          },
                          leading: CupertinoButton(
                            onPressed: () {
                              showProfileSmall(
                                  context: context, chatList: user);
                            },
                            padding: EdgeInsets.zero,
                            child: CircleAvatar(
                                radius: 24,
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
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    user.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
