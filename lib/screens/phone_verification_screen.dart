// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/providers/userDataProvider.dart';
import 'package:fly_chatting_app/screens/home_screen.dart';
import 'package:fly_chatting_app/screens/profile_screen.dart';
import 'package:fly_chatting_app/widgets/cupertino_button.dart';
import 'package:fly_chatting_app/widgets/cupertino_text_button.dart';
import 'package:fly_chatting_app/widgets/theme/colors_style.dart';
import 'package:fly_chatting_app/widgets/messenger_scaffold.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({
    super.key,
    required this.verificationId,
    this.phoneNumber,
    this.number,
  });

  final String verificationId;
  final String? phoneNumber;
  final String? number;

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final TextEditingController _pinCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: CupertinoButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 34,
          ),
        ),
      ),
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
                  style: const TextStyle(fontSize: 18, color: AppColors.darkBlueColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 70),
                pinCode(),
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
      final User? user = FirebaseAuth.instance.currentUser;
      final String uid = user!.uid;

      final checkUserData = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();

      if (checkUserData.docs.isNotEmpty) {
        final getUserdata = checkUserData.docs[0].data();
        UserModel userModel = UserModel.fromMap(getUserdata);

        log('---------------------------------------------------${userModel.fullName}-------------------------------------------------------');

        if (userModel != null) {
          context.read<UserDataProvider>().usersData();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(firebaseUser: user, userModel: userModel),
            ),
            (route) => false,
          );
        }
      } else {
        UserModel newUserCreate = UserModel(
            fullName: '',
            profilePicture: '',
            uid: uid,
            phoneNumber: widget.number,
            about: '');

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set(newUserCreate.toMap())
            .then((value) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  ProfileScreen(firebaseUser: user, userModel: newUserCreate),
            ),
            (route) => false,
          );
          log('new user created');
        });
      }
    }
  }

  Widget pinCode() {
    return PinCodeTextField(
      keyboardType: TextInputType.number,
      controller: _pinCodeController,
      length: 6,
      enableActiveFill: true,
      cursorColor: Colors.black,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        fieldWidth: 52,
        fieldHeight: 52,
        selectedColor: AppColors.darkBlueColor,
        activeColor: AppColors.darkBlueColor,
        inactiveColor: AppColors.lightBlueColor,
        disabledColor: AppColors.lightBlueColor,
        selectedFillColor: AppColors.lightFullBlueColor,
        inactiveFillColor: AppColors.lightFullBlueColor,
        activeFillColor: Colors.transparent,
        borderWidth: 2,
        borderRadius: BorderRadius.circular(14),
      ),
      appContext: context,
      onChanged: (String value) {
        log(value);
      },
    );
  }
}
