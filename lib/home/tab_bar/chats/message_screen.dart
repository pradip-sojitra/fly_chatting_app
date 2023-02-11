import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/home/tab_bar/chats/widgets/bottom_text_field.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/providers/chat_provider.dart';
import 'package:fly_chatting_app/widgets/theme/colors_style.dart';
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


  @override
  Widget build(BuildContext context) {
    log('Build_MessageScreen');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: StreamBuilder<UserModel>(
            stream:
                context.watch<ChatProvider>().userData(widget.receiverId),
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
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              reverse: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      splashColor: AppColors.lightBlueColor,
                      onLongPress: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.lightFullBlueColor,
                            borderRadius: const BorderRadius.only(
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
                                const Text(
                                  'hii',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: const [
                                    SizedBox(height: 12),
                                    Text(
                                      '10:20',
                                      style: TextStyle(
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
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(6),
              child: BottomTextField(receiverId: widget.receiverId)),
        ],
      ),
    );
  }
}
