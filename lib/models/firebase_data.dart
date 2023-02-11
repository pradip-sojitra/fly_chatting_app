import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fly_chatting_app/models/local_db.dart';
import 'package:fly_chatting_app/models/user_model.dart';

class FirebaseData {
  static Future<UserModel?> userData({required String uid}) async {
    UserModel? userModel;

    final docSnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (docSnap.data() != null) {
      userModel = UserModel.fromJson(docSnap.data() as Map<String, dynamic>);
    }

    return userModel;
  }
}
