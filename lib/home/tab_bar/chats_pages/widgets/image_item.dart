import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/models/message_model.dart';
import 'package:intl/intl.dart';

class ImageItem extends StatelessWidget {
  const ImageItem({Key? key, required this.messages}) : super(key: key);
  final MessageModel messages;

  @override
  Widget build(BuildContext context) {
    bool checkData =
        messages.senderId == FirebaseAuth.instance.currentUser!.uid;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: messages.text,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
          ),
        ),
        Positioned(
          bottom: -0.1,
          right: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.only(left: 12, right: 8, top: 8),
              color: checkData ? Colors.grey.shade300 : Colors.white,
              child: Text(
                DateFormat.jm().format(
                  messages.time.toDate(),
                ),
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
        )
      ],
    );
  }
}
