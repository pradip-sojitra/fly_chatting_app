import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fly_chatting_app/common/utils.dart';
import 'package:fly_chatting_app/common/widgets/messenger_scaffold.dart';
import 'package:fly_chatting_app/models/group_model.dart';
import 'package:fly_chatting_app/models/message_model.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:uuid/uuid.dart';

class GroupChatProvider extends ChangeNotifier {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<UserModel?> selectedContacts = [];
  List<String> selectedMessagesId = [];

  void selectContact({required UserModel? userData}) {
    if (selectedContacts.contains(userData)) {
      selectedContacts.remove(userData);
    } else {
      selectedContacts.add(userData);
    }
    notifyListeners();
  }

  void selectMessage({required String messageId}) {
    if (selectedMessagesId.contains(messageId)) {
      selectedMessagesId.remove(messageId);
    } else {
      selectedMessagesId.add(messageId);
    }
    notifyListeners();
    print("--------------- -------------- $selectedMessagesId ---------------- -----------------");
  }

  void selectMessageClear(){
    selectedMessagesId.clear();
    notifyListeners();
  }

  void createGroup({
    required BuildContext context,
    required String groupName,
    required File groupImage,
  }) async {
    try {
      final String groupId = const Uuid().v1();
      final DateTime time = DateTime.now();
      List<String> selectedUid = [];
      for (var contact in selectedContacts) {
        selectedUid.add(contact!.uid);
      }

      String profileImage =
          await storeFileToFirebase('group/$groupId}', groupImage);

      GroupModel group = GroupModel(
        senderId: auth.currentUser!.uid,
        groupName: groupName,
        groupId: groupId,
        lastMessage: '',
        groupProfilePic: profileImage,
        membersUid: [auth.currentUser!.uid, ...selectedUid],
        time: time,
      );

      await fireStore.collection('groups').doc(groupId).set(group.toJson());
    } catch (e) {
      Messenger().messengerScaffold(text: e.toString(), context: context);
    }
  }

  Stream<List<GroupModel>> getChatGroups() {
    return fireStore.collection('groups').snapshots().map((event) {
      List<GroupModel> groups = [];
      for (var document in event.docs) {
        var group = GroupModel.fromJson(document.data());
        if (group.membersUid.contains(auth.currentUser!.uid)) {
          groups.add(group);
        }
      }
      return groups;
    });
  }
}
