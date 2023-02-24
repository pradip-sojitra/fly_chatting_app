import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/widgets/image_item.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/widgets/video_player_item.dart';
import 'package:fly_chatting_app/models/message_enum.dart';
import 'package:fly_chatting_app/models/message_model.dart';
import 'package:intl/intl.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final MessageModel messages;

  const DisplayTextImageGIF({Key? key, required this.messages})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool checkData =
        messages.senderId == FirebaseAuth.instance.currentUser!.uid;
    return messages.type == MessageEnum.text
        ? Text(
            messages.text,
            style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontFamily: "Varela Round Regular",
                color: Colors.black),
          )
        : messages.type == MessageEnum.video
            ? VideoPlayerItem(messages: messages)
            : ImageItem(messages: messages);
  }
}
