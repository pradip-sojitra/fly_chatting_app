import 'package:cached_video_player/cached_video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/models/message_model.dart';
import 'package:intl/intl.dart';

class VideoPlayerItem extends StatefulWidget {
  const VideoPlayerItem({Key? key, required this.messages}) : super(key: key);

  final MessageModel messages;

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerController videoController;
  bool isPlay = false;

  @override
  void initState() {
    super.initState();
    videoController = CachedVideoPlayerController.network(widget.messages.text)
      ..initialize().then((value) {
        videoController.setVolume(1);
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool checkData =
        widget.messages.senderId == FirebaseAuth.instance.currentUser!.uid;
    return AspectRatio(
      aspectRatio: videoController.value.aspectRatio,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedVideoPlayer(videoController),
          ),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if (isPlay) {
                  videoController.pause();
                } else {
                  videoController.play();
                }
                setState(() {
                  isPlay = !isPlay;
                });
              },
              icon: Icon(
                isPlay ? Icons.pause_circle : Icons.play_circle,
                size: 70,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: -0.1,
            right: 0,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(12)),
              child: Container(
                padding: const EdgeInsets.only(left: 12, right: 8, top: 8),
                color: checkData ? Colors.blue.shade100 : Colors.grey.shade300,
                child: Text(
                  DateFormat.jm().format(
                    widget.messages.time.toDate(),
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
      ),
    );
  }
}
