import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fly_chatting_app/models/chats_check_participant_model.dart';
import 'package:fly_chatting_app/models/local_db.dart';
import 'package:fly_chatting_app/models/user_model.dart';

class FirebaseData {
 static Future<UserModel?> userData({required String uid}) async {
    UserModel? userModel;

    final docSnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (docSnap.data() != null) {
      userModel = UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }

    return userModel;
  }

 static Future<ChatCheckModel?> getParticipantChat(UserModel targetUser) async {
   ChatCheckModel? chatCheckData;

   final checkTargetChat = await FirebaseFirestore.instance
       .collection('chatCheck')
       .where('participant.${sharedPref.uid}', isEqualTo: true)
       .where('participant.${targetUser.uid}', isEqualTo: true)
       .get();

   if (checkTargetChat.docs.isNotEmpty) {
     ChatCheckModel existParticipant =
     ChatCheckModel.fromMap(checkTargetChat.docs[0].data());
     chatCheckData = existParticipant;
     log('chat is exists');
   } else {
     final String chatId = DateTime.now().microsecondsSinceEpoch.toString();
     ChatCheckModel newParticipant = ChatCheckModel(
       chatId: chatId,
       lastMessage: '',
       lastTime: '',
       participant: {
         sharedPref.uid.toString(): true,
         targetUser.uid.toString(): true,
       },
     );

     await FirebaseFirestore.instance
         .collection('chatCheck')
         .doc(newParticipant.chatId)
         .set(newParticipant.toMap());

     chatCheckData = newParticipant;
     log('new chatScreen is created');
   }
   return chatCheckData;
 }
}
