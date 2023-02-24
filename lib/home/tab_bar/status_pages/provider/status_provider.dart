// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fly_chatting_app/common/provider/commom_provider.dart';
import 'package:fly_chatting_app/common/widgets/messenger_scaffold.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/provider/chat_&_message_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/provider/contact_service_provider.dart';
import 'package:fly_chatting_app/models/status_model.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class StatusProvider extends ChangeNotifier {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> uploadStatus({
    required File file,
    required BuildContext context,
  }) async {
    try {
      final UserModel? userData = await context
          .read<ChatProvider>()
          .userData(uid: auth.currentUser!.uid);
      final String statusId = const Uuid().v1();

      String imageUrl = await context
          .read<CommonFirebaseStorageProvider>()
          .storeFileToFirebase('status/$statusId${userData!.uid}', file);

      List<UserModel?> contacts =
          await context.read<ContactProvider>().getPhoneInvite();

      List<String> uidWhoCanSee = [];

      for (var contact in contacts) {
        var userDataFirebase = await fireStore
            .collection('users')
            .where('phoneNumber',
                isEqualTo: contact!.phoneNumber
                    .replaceAll(' ', '')
                    .replaceAll('+91', '')
                    .replaceAll('-', ''))
            .get();

        print(
            '------------------------- $userDataFirebase -----------------------------');

        if (userDataFirebase.docs.isNotEmpty) {
          var userData = UserModel.fromJson(userDataFirebase.docs.first.data());
          uidWhoCanSee.add(userData.uid);
          print(
              '------------------------- ${userData.uid} -----------------------------');
        }
      }

      List<String> statusImageUrls = [];
      var statusesSnapshot = await fireStore
          .collection('status')
          .where(
            'uid',
            isEqualTo: auth.currentUser!.uid,
          )
          .get();

      if (statusesSnapshot.docs.isNotEmpty) {
        StatusModel status =
            StatusModel.fromJson(statusesSnapshot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageUrl);
        await fireStore
            .collection('status')
            .doc(statusesSnapshot.docs[0].id)
            .update({
          'photoUrl': statusImageUrls,
        });
        return;
      } else {
        statusImageUrls = [imageUrl];
      }

      StatusModel status = StatusModel(
        uid: auth.currentUser!.uid,
        userName: userData.fullName,
        phoneNumber: userData.phoneNumber,
        photoUrl: statusImageUrls,
        time: DateTime.now(),
        profilePic: userData.profilePicture!,
        statusId: statusId,
        whoCanSee: uidWhoCanSee,
      );

      await fireStore.collection('status').doc(statusId).set(status.toJson());
    } catch (e) {
      print(
          '------------------------------------ ${e.toString()} ------------------------------------------');
      Messenger().messengerScaffold(text: e.toString(), context: context);
    }
  }

  Future<List<StatusModel>> getStatus({required BuildContext context}) async {
    List<StatusModel> statusData = [];

    try {
      List<UserModel?> contacts =
          await context.read<ContactProvider>().getPhoneInvite();

      for (var contact in contacts) {
        var statusSnapshot = await fireStore
            .collection('status')
            .where('phoneNumber',
                isEqualTo: contact!.phoneNumber
                    .replaceAll(' ', '')
                    .replaceAll('+91', '')
                    .replaceAll('-', ''))
            .where('time',
                isGreaterThan: DateTime.now()
                    .subtract(const Duration(hours: 24))
                    .millisecondsSinceEpoch)
            .get();

        for (var tempData in statusSnapshot.docs) {
          StatusModel tempStatus = StatusModel.fromJson(tempData.data());
          if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
            statusData.add(tempStatus);
          }
        }
      }
    } catch (e) {
      print(e);
      Messenger().messengerScaffold(text: e.toString(), context: context);
    }
    return statusData;
  }
}
