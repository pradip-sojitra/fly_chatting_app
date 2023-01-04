import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fly_chatting_app/models/user_model.dart';

class FirebaseData {
 static Future<UserModel?> getUserData({required String uid}) async {
    UserModel? userModel;

    DocumentSnapshot docSnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (docSnap.data() != null) {
      userModel = UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }

    return userModel;
  }
}
