// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class BottomTextField extends StatefulWidget {
  const BottomTextField({Key? key, required this.receiverId}) : super(key: key);
  final String receiverId;

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

  void messageSend() {
    if (isShowSendButton) {
      if (messageController.text.isNotEmpty) {
        context.read<ChatProvider>().messagesSet(
            context: context,
            text: messageController.text.trim(),
            receiverId: widget.receiverId);
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
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.gif,
                            size: 38,
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
                          onTap: () {},
                          child: const Icon(
                            Icons.camera_alt,
                            size: 26,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {},
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
