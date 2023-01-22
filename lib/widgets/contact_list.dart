// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/models/chats_check_participant_model.dart';
import 'package:fly_chatting_app/models/firebase_data.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/screens/ChatScreen.dart';
import 'package:fly_chatting_app/widgets/theme/colors_style.dart';

class ContactList extends StatelessWidget {
  const ContactList(
      {Key? key,
      required this.index,
     required this.names,
     required this.numbers,
      this.images,
      this.nameFirst})
      : super(key: key);

  final int index;
  final List<String> names;
  final List<String> numbers;
  final List<Uint8List?>? images;
  final List<String>? nameFirst;

  @override
  Widget build(BuildContext context) {
    final isCheckImage = images![index]!.isNotEmpty;
    return ListTile(
      onTap: () async {
        final number = numbers[index]
            .replaceAll('-', '')
            .replaceAll(' ', '')
            .replaceAll('+91', '')
            .replaceAll('+261', '');

        final targetData = await FirebaseFirestore.instance
            .collection('users')
            .where('phoneNumber', isEqualTo: number)
            .get();

        UserModel targetUser = UserModel.fromMap(targetData.docs[0].data());

        log('---------------------local-----------------------$number----------------------------------------------------');
        log('---------------------fireStoreData-----------------------${targetUser.fullName}, ${targetUser.phoneNumber}---------------------------');

        ChatCheckModel? chatCheck = await FirebaseData.getParticipantChat(targetUser);

        if (chatCheck != null) {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                targetUser: targetUser,
                chatCheck: chatCheck,
              ),
            ),
          );
        }
      },
      title: Text(names[index]),
      subtitle: Text(numbers[index]),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.lightBlueColor.withOpacity(0.8),
        backgroundImage: isCheckImage ? MemoryImage(images![index]!) : null,
        child: Center(
          child: isCheckImage
              ? null
              : Text(
                  nameFirst![index].toUpperCase(),
                  style: const TextStyle(fontSize: 22, color: Colors.black),
                ),
        ),
      ),
    );
  }
}
