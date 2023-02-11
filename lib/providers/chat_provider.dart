// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/home/tab_bar/chats/message_screen.dart';
import 'package:fly_chatting_app/models/chat_list_model.dart';
import 'package:fly_chatting_app/models/message_enum.dart';
import 'package:fly_chatting_app/models/message_model.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/widgets/messenger_scaffold.dart';
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<UserModel> userData(String userId) {
    return fireStore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((event) => UserModel.fromJson(event.data()!));
  }

  Future<void> isOnlineChanged(bool isOnline) async {
    await fireStore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .update({'isOnline': isOnline});
  }

  Stream<List<ChatListModel>> getChatList() {
    return fireStore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatListModel> chatLists = [];
      for (var document in event.docs) {
        var chatList = ChatListModel.fromJson(document.data());
        var userData = await fireStore.collection('users').doc(chatList.id).get();
        var user = UserModel.fromJson(userData.data()!);

        chatLists.add(ChatListModel(
            name: user.fullName,
            profilePic: user.profilePicture!,
            id: chatList.id,
            time: chatList.time,
            lastMessage: chatList.lastMessage));
      }
      return chatLists;
    });
  }

  Future<void> selectContact(
      {required BuildContext context,
      required UserModel receiverAllData}) async {
    try {
      final receiver = await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: receiverAllData.phoneNumber)
          .get();

      if (receiver.docs.isNotEmpty) {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MessageScreen(
              receiverId: receiverAllData.uid,
            ),
          ),
        );
      }
    } catch (e) {
      Messenger().messengerScaffold(text: e.toString(), context: context);
    }
  }

  Future<void> _usersChatListSet(
      {required UserModel receiverData,
      required UserModel senderData,
      required String text,
      required Timestamp time}) async {
    ChatListModel sendersAllData = ChatListModel(
        name: senderData.fullName,
        profilePic: senderData.profilePicture!,
        id: senderData.uid,
        time: time,
        lastMessage: text);
    await fireStore
        .collection('users')
        .doc(receiverData.uid)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(sendersAllData.toJson());

    ChatListModel receiversAllData = ChatListModel(
        name: receiverData.fullName,
        profilePic: receiverData.profilePicture!,
        id: receiverData.uid,
        time: time,
        lastMessage: text);
    await fireStore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverData.uid)
        .set(receiversAllData.toJson());
  }

  Future<void> _usersMessageDataSet({
    required UserModel senderData,
    required UserModel receiverData,
    required String text,
    required Timestamp time,
    required String messageId,
  }) async {
    MessageModel message = MessageModel(
        receiverId: receiverData.uid,
        senderId: senderData.uid,
        messageId: messageId,
        text: text,
        time: time,
        isSeen: false,
        type: MessageEnum.text);
    await fireStore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('chats')
        .doc(receiverData.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toJson());
    await fireStore
        .collection('users')
        .doc(receiverData.uid)
        .collection('chats')
        .doc(auth.currentUser?.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toJson());
  }

  Future<void> messagesSet(
      {required BuildContext context,
      required String text,
      required String receiverId}) async {
    try {
      Timestamp time = Timestamp.now();
      String messageId = const Uuid().v1();

      var receiver = await fireStore.collection('users').doc(receiverId).get();
      UserModel receiverData = UserModel.fromJson(receiver.data()!);

      var sender =
          await fireStore.collection('users').doc(auth.currentUser?.uid).get();
      UserModel senderData = UserModel.fromJson(sender.data()!);

      _usersChatListSet(
          receiverData: receiverData,
          senderData: senderData,
          text: text,
          time: time);
      _usersMessageDataSet(
          senderData: senderData,
          receiverData: receiverData,
          time: time,
          text: text,
          messageId: messageId);
    } catch (e) {
      Messenger().messengerScaffold(text: e.toString(), context: context);
    }
  }
}
