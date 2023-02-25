import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/common/widgets/theme/colors_style.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/screens/message_screen.dart';
import 'package:fly_chatting_app/models/chat_list_model.dart';

void showProfileSmall({required BuildContext context,required ChatListModel chatList}) {
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
                  image: NetworkImage(chatList.profilePic),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.20),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      chatList.name,
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
                        return MessageScreen(
                          receiverId: chatList.id,
                        );
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