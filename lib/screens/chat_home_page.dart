import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/models/chats_check_participant_model.dart';
import 'package:fly_chatting_app/models/firebase_data.dart';
import 'package:fly_chatting_app/models/local_db.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/screens/ChatScreen.dart';
import 'package:fly_chatting_app/widgets/theme/colors_style.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({Key? key}) : super(key: key);

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chatCheck')
          .where('participant.${sharedPref.uid}', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasData) {
            return ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  ChatCheckModel chatCheck =
                      ChatCheckModel.fromMap(snapshot.data!.docs[index].data());
                  List<String> participantKeys =
                      chatCheck.participant!.keys.toList();
                  participantKeys.remove(sharedPref.uid);

                  return FutureBuilder(
                    future: FirebaseData.userData(uid: participantKeys[0]),
                    builder: (context, userData) {
                      if (userData.connectionState == ConnectionState.done) {
                        if (userData.data != null) {
                          UserModel targetUsers = userData.data!;
                          return ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return ChatScreen(
                                      targetUser: targetUsers,
                                      chatCheck: chatCheck);
                                },
                              ));
                            },
                            leading: CupertinoButton(
                              onPressed: () {
                                showProfilePicture(targetUsers, chatCheck);
                              },
                              padding: EdgeInsets.zero,
                              child: CircleAvatar(
                                  radius: 26,
                                  backgroundColor: Colors.blueGrey.shade50,
                                  backgroundImage: targetUsers.profilePicture ==
                                          null
                                      ? null
                                      : NetworkImage(targetUsers.profilePicture
                                          .toString()),
                                  child: targetUsers.profilePicture == null
                                      ? const Image(
                                          image: AssetImage(
                                              'assets/icons/person_2.png'),
                                          height: 38,
                                          color: Color(0xffadb5bd),
                                        )
                                      : null),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  targetUsers.fullName.toString(),
                                  style: const TextStyle(
                                      fontFamily: 'Rounded ExtraBold'),
                                ),
                                const Spacer(),
                                Text(
                                  chatCheck.lastTime.toString(),
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              chatCheck.lastMessage.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                        return Container();
                      } else {
                        return Container();
                      }
                    },
                  );
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
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              child: Text('No Chats'),
            );
          }
        }
      },
    );
  }

  void showProfilePicture(UserModel targetUsers, ChatCheckModel chatCheck) {
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
                        image:
                            NetworkImage(targetUsers.profilePicture.toString()),
                        fit: BoxFit.cover)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.20),
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        targetUsers.fullName.toString(),
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
                          return ChatScreen(
                              targetUser: targetUsers, chatCheck: chatCheck);
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
