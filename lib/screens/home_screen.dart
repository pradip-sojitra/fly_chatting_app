import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/models/chats_check_participant_model.dart';
import 'package:fly_chatting_app/models/firebase_data.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/screens/ChatScreen.dart';
import 'package:fly_chatting_app/screens/contacts._screen.dart';
import 'package:fly_chatting_app/screens/login_Screen.dart';
import 'package:fly_chatting_app/widgets/theme/colors_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.userModel,
    required this.firebaseUser,
  });

  final User firebaseUser;
  final UserModel userModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: const [
            Image(
              image: AssetImage('assets/images/main_icon_3_5.png'),
              height: 60,
              width: 60,
            ),
            SizedBox(width: 10),
            Text(
              'FlyChat',
              style: TextStyle(letterSpacing: 0.6, fontFamily: 'Rounded Black'),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Image(
              image: AssetImage('assets/icons/search.png'),
              height: 25,
            ),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              });
            },
            icon: const Image(
              image: AssetImage('assets/icons/menu-vertical.png'),
              height: 28,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chatCheck')
            .where('participant.${widget.userModel.uid}', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData) {
              return ListView.separated(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    ChatCheckModel chatCheck = ChatCheckModel.fromMap(
                        snapshot.data!.docs[index].data());
                    List<String> participantKeys =
                        chatCheck.participant!.keys.toList();

                    participantKeys.remove(widget.userModel.uid);

                    return FutureBuilder(
                      future: FirebaseData.getUserData(uid: participantKeys[0]),
                      builder: (context, userData) {
                        if (userData.connectionState == ConnectionState.done) {
                          if (userData.data != null) {
                            UserModel targetUsers = userData.data!;
                            return ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return ChatScreen(
                                        userModel: widget.userModel,
                                        firebaseUser: widget.firebaseUser,
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
                                    backgroundImage:
                                        targetUsers.profilePicture == null
                                            ? null
                                            : NetworkImage(targetUsers
                                                .profilePicture
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.lightBlueColor,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<dynamic>(
              builder: (context) {
                return ContactScreen(
                  firebaseUser: widget.firebaseUser,
                  userModel: widget.userModel,
                );
              },
            ),
          );
        },
        child: const Icon(Icons.chat),
      ),
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
                              userModel: widget.userModel,
                              firebaseUser: widget.firebaseUser,
                              targetUser: targetUsers,
                              chatCheck: chatCheck);
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
