// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/common/widgets/cupertino_button.dart';
import 'package:fly_chatting_app/common/widgets/cupertino_text_button.dart';
import 'package:fly_chatting_app/common/widgets/messenger_scaffold.dart';
import 'package:fly_chatting_app/common/widgets/pincode.dart';
import 'package:fly_chatting_app/common/widgets/theme/colors_style.dart';
import 'package:fly_chatting_app/home/home_screen.dart';
import 'package:fly_chatting_app/common/local_db/local_db.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/auth/screens/profile_screen.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({
    super.key,
    required this.verificationId,
    this.phoneNumber,
    required this.number,
  });

  final String verificationId;
  final String? phoneNumber;
  final String number;

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final TextEditingController _pinCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter Your Code',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                const Text(
                  'We have sent you an SMS with the code to ',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  widget.phoneNumber.toString(),
                  style: const TextStyle(
                      fontSize: 18, color: AppColors.darkBlueColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 70),
                PinCode(controller: _pinCodeController),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Code didn't send ?"),
                    BuildCupertinoButtonText(onPressed: () {}, title: 'Resend'),
                  ],
                ),
                const SizedBox(height: 50),
                BuildCupertinoButton(
                  onPressed: () {
                    checkValues();
                  },
                  title: 'Verify',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkValues() {
    final String pinCode = _pinCodeController.text.trim();
    if (pinCode == '') {
      Messenger().messengerScaffold(text: 'OTP is required', context: context);
    } else {
      signInWithPhoneNumber(otpCode: pinCode);
    }
  }

  Future<void> signInWithPhoneNumber({required String otpCode}) async {
    PhoneAuthCredential? credential;
    try {
      credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (_) {
      Messenger().messengerScaffold(text: 'Failed', context: context);
    }

    if (credential != null) {
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      final checkUserData = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();

      if (checkUserData.docs.isNotEmpty) {
        UserModel currentUserData = UserModel.fromJson(checkUserData.docs[0].data());

        setState(() {
          sharedPref.uid = currentUserData.uid.toString();
          sharedPref.fullName = currentUserData.fullName.toString();
          sharedPref.phoneNumber = currentUserData.phoneNumber.toString();
          sharedPref.profilePicture = currentUserData.profilePicture.toString();
          sharedPref.about = currentUserData.about.toString();
          log('------------------------------------- data added --------------------------------------');
        });

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );

        // log('---------------------------------------------------${userModel.fullName}-------------------------------------------------------');
      } else {
        UserModel newUserCreate = UserModel(
          fullName: '',
          profilePicture: '',
          uid: uid,
          phoneNumber: widget.number,
          about: '',
          active: true,
          isSeen: DateTime.now().millisecondsSinceEpoch
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set(newUserCreate.toJson())
            .then((value) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  ProfileScreen(userModel: newUserCreate),
            ),
            (route) => false,
          );
          log('new user created');
        });
      }

    }
  }
}
