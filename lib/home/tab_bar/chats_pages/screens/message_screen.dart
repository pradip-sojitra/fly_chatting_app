// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fly_chatting_app/home/tab_bar/calls_pages/provider/calls_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/calls_pages/screens/pickup/pickup_layout.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/widgets/Display_text_image_video_gif.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/widgets/bottom_text_field.dart';
import 'package:fly_chatting_app/models/message_enum.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/provider/chat_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({
    super.key,
    required this.receiverId,
    required this.isGroupChat,
    required this.name,
    required this.photo,
  });

  final String receiverId;
  final bool isGroupChat;
  final String name;
  final String photo;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  ScrollController scrollController = ScrollController();

  String lastSeenMessage(lastSeen) {
    final difference = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(lastSeen));

    final String finalSeen = difference.inSeconds > 59
        ? difference.inMinutes > 59
            ? difference.inDays > 23
                ? "${difference.inDays} ${difference.inDays == 1 ? "day" : "days"}"
                : "${difference.inHours} ${difference.inHours == 1 ? "hour" : "hours"}"
            : "${difference.inMinutes} ${difference.inMinutes == 1 ? "minute" : "minutes"}"
        : "few moments";

    return finalSeen;
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayoutScreen(
      scaffold: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: widget.isGroupChat
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
                        backgroundImage: NetworkImage(widget.photo),
                      ),
                    ],
                  ),
                  contentPadding: EdgeInsets.zero,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
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
                  stream: context
                      .watch<ChatProvider>()
                      .fireUserData(widget.receiverId),
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
                stream: context
                    .watch<ChatProvider>()
                    .fireUserData(widget.receiverId),
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
                    icon: const Icon(Icons.video_call),
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
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: widget.isGroupChat
                    ? context
                        .read<ChatProvider>()
                        .getGroupChatStream(groupId: widget.receiverId)
                    : context
                        .read<ChatProvider>()
                        .getChat(receiverId: widget.receiverId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  });

                  return ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var messages = snapshot.data![index];
                      bool isSender = messages.senderId ==
                          FirebaseAuth.instance.currentUser!.uid;

                      final bool isNip = (index == 0) ||
                          (index == snapshot.data!.length - 1 &&
                              messages.senderId !=
                                  snapshot.data![index - 1].senderId) ||
                          (messages.senderId !=
                                  snapshot.data![index - 1].senderId &&
                              messages.senderId ==
                                  snapshot.data![index + 1].senderId) ||
                          (messages.senderId !=
                                  snapshot.data![index - 1].senderId &&
                              messages.senderId !=
                                  snapshot.data![index + 1].senderId);

                      final bool isShowDate = (index == 0) ||
                          ((index == snapshot.data!.length - 1) &&
                              (messages.time.toDate().day >
                                  snapshot.data![index - 1].time
                                      .toDate()
                                      .day)) ||
                          (messages.time.toDate().day >
                                  snapshot.data![index - 1].time
                                      .toDate()
                                      .day) &&
                              (messages.time.toDate().day <=
                                  snapshot.data![index + 1].time.toDate().day);

                      return Column(
                        children: [
                          if (isShowDate)
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade100
                                        .withOpacity(.6),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  "${DateFormat.d().format(
                                    messages.time.toDate(),
                                  )} ${DateFormat.MMMM().format(
                                    messages.time.toDate(),
                                  )} ${DateFormat.y().format(
                                    messages.time.toDate(),
                                  )}",
                                  style: const TextStyle(
                                      fontFamily: "Rounded ExtraBold",
                                      color: Colors.blueGrey,
                                      fontSize: 13),
                                ),
                              ),
                            ),
                          Container(
                            alignment: isSender
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            margin: EdgeInsets.only(
                                top: isNip ? 14 : 3,
                                left: isSender
                                    ? 50
                                    : !isNip
                                        ? 22
                                        : 20,
                                right: !isSender
                                    ? 50
                                    : !isNip
                                        ? 22
                                        : 20),
                            child: CustomPaint(
                              painter: isNip
                                  ? CustomChatBubble(
                                      color: isSender
                                          ? Colors.blue.shade100
                                          : Colors.grey.shade300,
                                      isOwn: isSender ? true : false)
                                  : null,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onLongPress: () async {
                                  if (widget.isGroupChat) {
                                    await FirebaseFirestore.instance
                                        .collection("groups")
                                        .doc(widget.receiverId)
                                        .collection("chats")
                                        .doc(messages.messageId)
                                        .delete();
                                  }
                                  {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.uid)
                                        .collection('chats')
                                        .doc(widget.receiverId)
                                        .collection('messages')
                                        .doc(messages.messageId)
                                        .delete();
                                  }
                                },
                                child: Container(
                                  padding: MessageEnum.text == messages.type
                                      ? EdgeInsets.only(
                                          top: 4,
                                          bottom: 4,
                                          left: isSender
                                              ? 10
                                              : isNip
                                                  ? 10
                                                  : 10,
                                          right: isSender
                                              ? isNip
                                                  ? 10
                                                  : 10
                                              : 10)
                                      : EdgeInsets.only(
                                          top: 6,
                                          bottom: 6,
                                          left: isSender
                                              ? 6
                                              : isNip
                                                  ? 18
                                                  : 6,
                                          right: isSender
                                              ? !isNip
                                                  ? 6
                                                  : 18
                                              : 6),
                                  decoration: BoxDecoration(
                                      color: !isNip
                                          ? isSender
                                              ? Colors.blue.shade100
                                              : Colors.grey.shade300
                                          : null,
                                      borderRadius: !isNip
                                          ? BorderRadius.circular(12)
                                          : null),
                                  child: Stack(
                                    children: [
                                      if (widget.isGroupChat)
                                        if (!isSender)
                                          if (isNip)
                                            Text(
                                              messages.senderName,
                                              style: const TextStyle(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w900,
                                                fontFamily:
                                                    "Varela Round Regular",
                                                color: Colors.red,
                                              ),
                                            ),
                                      DisplayTextImageGIF(
                                          messages: messages,
                                          isNip: isNip,
                                          isGroupChat: widget.isGroupChat),
                                      const SizedBox(width: 10),
                                      if (messages.type == MessageEnum.text)
                                        const SizedBox(height: 6),
                                      if (messages.type == MessageEnum.text)
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Text(
                                            DateFormat.jm()
                                                .format(messages.time.toDate()),
                                            style: TextStyle(
                                                fontSize: 11.5,
                                                color: Colors.grey.shade500,
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ),
                                      const SizedBox(width: 10)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 6, left: 6),
              child: BottomTextField(
                receiverId: widget.receiverId,
                isGroupChat: widget.isGroupChat,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomChatBubble extends CustomPainter {
  CustomChatBubble({required this.color, required this.isOwn});

  final Color color;
  final bool isOwn;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    Path paintBubbleTail() {
      Path path = Path();
      if (!isOwn) {
        path = Path()
          ..moveTo(5, size.height - 5)
          ..quadraticBezierTo(-5, size.height, -12, size.height - 4)
          ..quadraticBezierTo(-5, size.height - 5, 0, size.height - 17);
      }
      if (isOwn) {
        path = Path()
          ..moveTo(size.width - 6, size.height - 4)
          ..quadraticBezierTo(
              size.width + 5, size.height, size.width + 12, size.height - 4)
          ..quadraticBezierTo(
              size.width + 5, size.height - 5, size.width, size.height - 17);
      }
      return path;
    }

    final RRect bubbleBody = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(12));
    final Path bubbleTail = paintBubbleTail();

    canvas.drawRRect(bubbleBody, paint);
    canvas.drawPath(bubbleTail, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

/*  Center(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    timeago.format(messages.time.toDate()),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: Colors.grey),
                                  ),
                                ),
                              ),  */
