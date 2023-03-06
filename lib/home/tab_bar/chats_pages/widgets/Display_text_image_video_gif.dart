import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/widgets/image_item.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/widgets/video_player_item.dart';
import 'package:fly_chatting_app/models/message_enum.dart';
import 'package:fly_chatting_app/models/message_model.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final MessageModel messages;
  final bool isNip;
  final bool isGroupChat;

  const DisplayTextImageGIF(
      {Key? key,
      required this.messages,
      required this.isNip,
      required this.isGroupChat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSender = messages.senderId == FirebaseAuth.instance.currentUser!.uid;
    return messages.type == MessageEnum.text
        ? Padding(
            padding: EdgeInsets.only(
                bottom: 5,
                top: isGroupChat
                    ? !isSender
                        ? isNip
                            ? 16
                            : 0
                        : 0
                    : 0),
            child: Text(
              "${messages.text}              ",
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          )
        : messages.type == MessageEnum.video
            ? VideoPlayerItem(messages: messages)
            : ImageItem(messages: messages);
  }
}
