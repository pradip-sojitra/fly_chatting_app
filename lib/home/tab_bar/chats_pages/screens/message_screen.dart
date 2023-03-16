// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fly_chatting_app/home/tab_bar/calls_pages/screens/pickup/pickup_layout.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/group_chats/widgets/message_appbar.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/group_chats/provider/group_chat_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/widgets/Display_text_image_video_gif.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/widgets/bottom_text_field.dart';
import 'package:fly_chatting_app/models/message_enum.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<GroupChatProvider>().selectedMessagesId.clear();
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayoutScreen(
      scaffold: Scaffold(
        appBar: MessageAppBar(
            photo: widget.photo,
            name: widget.name,
            isGroupChat: widget.isGroupChat,
            receiverId: widget.receiverId),
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
                            decoration: BoxDecoration(
                                color: context
                                        .watch<GroupChatProvider>()
                                        .selectedMessagesId
                                        .contains(messages.messageId)
                                    ? Colors.lightGreen.shade100
                                        .withOpacity(.60)
                                    : null),
                            child: Container(
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
                                  onLongPress: () {
                                    if (context.read<GroupChatProvider>().selectedMessagesId.isEmpty) {
                                      context.read<GroupChatProvider>().selectMessage(messageId: messages.messageId);
                                    }
                                  },
                                  onTap: () {
                                    if (context.read<GroupChatProvider>().selectedMessagesId.isNotEmpty) {
                                      context.read<GroupChatProvider>().selectMessage(messageId: messages.messageId);
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
                                              DateFormat.jm().format(
                                                  messages.time.toDate()),
                                              style: TextStyle(
                                                fontSize: 11.5,
                                                color: Colors.grey.shade500,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
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
/*       {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.uid)
                                        .collection('chats')
                                        .doc(widget.receiverId)
                                        .collection('messages')
                                        .doc(messages.messageId)
                                        .delete();
                                  }*/
