import 'dart:developer';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fly_chatting_app/auth/screens/phone_verification_screen.dart';
import 'package:fly_chatting_app/common/widgets/cupertino_button.dart';
import 'package:fly_chatting_app/common/widgets/messenger_scaffold.dart';
import 'package:fly_chatting_app/common/widgets/theme/colors_style.dart';
import 'package:fly_chatting_app/common/local_db/local_db.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  String isCheckValue = '';
  bool rememberMe = false;
  String? fullPhoneNumber;

  String? countryCode;

  void isCountryCodeCheck() {
    if (countryCode != null) {
      countryCode;
    } else {
      countryCode = '91';
    }
  }

  @override
  void initState() {
    isCountryCodeCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const SizedBox(
                  width: 250,
                  height: 250,
                  child: Image(
                    image: AssetImage('assets/images/main_icon_3_2.png'),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter Your Phone Number',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Please confirm your country code and enter your phone number',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Container(
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isCheckValue.isEmpty
                          ? AppColors.lightBlueColor
                          : AppColors.darkBlueColor,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      CupertinoButton(
                        onPressed: () async {
                          countrySelected();
                        },
                        child: Text(
                          '+${countryCode.toString()}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneNumberController,
                          onChanged: (value) {
                            setState(() {
                              isCheckValue = value;
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Phone Number',
                            border: InputBorder.none,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        value: rememberMe,
                        activeColor: AppColors.darkBlueColor,
                        side: const BorderSide(
                            color: AppColors.lightBlueColor, width: 2.5),
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value!;
                          });
                        },
                      ),
                    ),
                    const Text(
                      'Remember me',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                const SizedBox(height: 40),
                BuildCupertinoButton(
                  onPressed: () {
                    checkValues();
                    log('------------------------------------- ${sharedPref.fullName} --------------------------------------');
                  },
                  title: 'Log In',
                ),
                const SizedBox(height: 110),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkValues() {
    final String phoneNumber = _phoneNumberController.text.trim();
    if (countryCode == '') {
      Messenger().messengerScaffold(
        text: 'Country Code is required',
        context: context,
      );
    } else if (phoneNumber == '') {
      Messenger().messengerScaffold(
        text: 'Phone Number is required',
        context: context,
      );
    } else {
      fullPhoneNumber = '+${countryCode.toString()}${_phoneNumberController.text}';
      verifyPhoneNumber(phoneNumber: fullPhoneNumber!);
    }
  }

  Future<void> verifyPhoneNumber({required String phoneNumber}) async {
    final String number = _phoneNumberController.text.trim();
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          Messenger()
              .messengerScaffold(text: 'verify Completed', context: context);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            Messenger().messengerScaffold(
              text: 'Invalid Phone Number',
              context: context,
            );
          }
          Messenger()
              .messengerScaffold(text: 'verify Failed', context: context);
        },
        timeout: const Duration(seconds: 60),
        codeSent: (String verificationId, int? resendToken) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PhoneVerificationScreen(
                verificationId: verificationId,
                phoneNumber: phoneNumber,
                number: number,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (_) {
      Messenger().messengerScaffold(text: 'Failed', context: context);
    }

  }

  void countrySelected() {
    showCountryPicker(
      context: context,
      favorite: ['IN'],
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        backgroundColor: Colors.blue.shade50,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(34),
          topLeft: Radius.circular(34),
        ),
        inputDecoration: InputDecoration(
          hintText: 'Search',
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide:
                const BorderSide(color: AppColors.darkBlueColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide:
                const BorderSide(color: AppColors.darkBlueColor, width: 2),
          ),
        ),
      ),
      onSelect: (Country value) {
        setState(() {
          countryCode = value.phoneCode;
        });
      },
    );
  }
}
