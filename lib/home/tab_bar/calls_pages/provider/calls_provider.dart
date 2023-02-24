// ignore_for_file: use_build_context_synchronously
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/home/tab_bar/calls_pages/screens/video_call.dart';
import 'package:fly_chatting_app/models/call_model.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:uuid/uuid.dart';

class CallProvider extends ChangeNotifier {
  final fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Stream<DocumentSnapshot> callStream() =>
      fireStore.collection('call').doc(auth.currentUser!.uid).snapshots();

  Future<bool> makeCall({required CallModel call}) async {
    try {
      call.hasDialled = true;
      await fireStore.collection('call').doc(call.callerId).set(call.toJson());
      call.hasDialled = false;
      await fireStore
          .collection('call')
          .doc(call.receiverId)
          .set(call.toJson());
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> endCall({required CallModel call}) async {
    try {
      await fireStore.collection('call').doc(call.callerId).delete();
      await fireStore.collection('call').doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  dial(
      {required UserModel sender,
      required UserModel receiver,
      required BuildContext context}) async {
    final String channelId = const Uuid().v4();
    CallModel call = CallModel(
      callerId: sender.uid,
      callerName: sender.fullName,
      callerPic: sender.profilePicture!,
      receiverId: receiver.uid,
      receiverName: receiver.fullName,
      receiverPic: receiver.profilePicture!,
      channelId: channelId,
    );

    bool callMade = await makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => VideoCallScreen(call: call),
      ));
    }
  }
}