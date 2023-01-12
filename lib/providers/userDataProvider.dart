import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/models/firebase_data.dart';
import 'package:fly_chatting_app/models/local_db.dart';
import 'package:fly_chatting_app/models/user_model.dart';

class UserDataProvider extends ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;

  void usersData() async {
    UserModel? userModel = await FirebaseData.getUserData(uid: user!.uid);

    if (userModel != null) {
      sharedPref.uid = userModel.uid.toString();
      sharedPref.phoneNumber = userModel.phoneNumber.toString();
      sharedPref.fullName = userModel.fullName.toString();
      sharedPref.profilePicture = userModel.profilePicture.toString();
      sharedPref.about = userModel.about.toString();
      print('----------------------------------------- Local UserData Added -----------------------------------------------');
    }
    notifyListeners();
  }
}