// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/common/utils.dart';
import 'package:fly_chatting_app/models/message_enum.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/provider/chat_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class BottomTextField extends StatefulWidget {
  const BottomTextField({
    Key? key,
    required this.receiverId,
    required this.isGroupChat,
  }) : super(key: key);

  final String receiverId;
  final bool isGroupChat;

  @override
  State<BottomTextField> createState() => _BottomTextFieldState();
}

class _BottomTextFieldState extends State<BottomTextField> {
  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  bool isShowSendButton = false;

  void selectImage() async {
    File? image = await selectedImage(context, ImageSource.gallery);
    if (image != null) {
      sendFileMessage(file: image, messageEnum: MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await selectedVideo(context, ImageSource.gallery);
    if (video != null) {
      sendFileMessage(file: video, messageEnum: MessageEnum.video);
    }
  }

  void sendFileMessage({required File file, required MessageEnum messageEnum}) {
    context.read<ChatProvider>().sendFileMessage(
          context: context,
          file: file,
          receiverId: widget.receiverId,
          messageEnum: messageEnum,
          isGroupChat: widget.isGroupChat,
        );
  }

  void messageSend() {
    if (isShowSendButton) {
      if (messageController.text.isNotEmpty) {
        context.read<ChatProvider>().sendTextMessage(
            context: context,
            text: messageController.text.trim(),
            receiverId: widget.receiverId,
            isGroupChat: widget.isGroupChat);
        setState(() {
          messageController.text = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Colors.blue,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Consumer<ChatProvider>(builder: (context, value, child) {
                return TextFormField(
                  minLines: 1,
                  maxLines: 3,
                  controller: messageController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    } else if (value.isEmpty) {
                      setState(() {
                        isShowSendButton = false;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Message',
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.only(
                      right: 15,
                      left: 25,
                      bottom: 15,
                      top: 15,
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 10.5),
                        InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.emoji_emotions,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 14),
                      ],
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 14),
                        InkWell(
                          onTap: selectImage,
                          child: const Icon(
                            Icons.camera_alt,
                            size: 26,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: selectVideo,
                          child: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                );
              }),
            ),
            GestureDetector(
              onTap: messageSend,
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 27,
                child: isShowSendButton
                    ? Container(
                        padding: const EdgeInsets.only(left: 5),
                        child: const Icon(
                          Icons.send_rounded,
                          size: 28,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.mic,
                        size: 28,
                        color: Colors.white,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
