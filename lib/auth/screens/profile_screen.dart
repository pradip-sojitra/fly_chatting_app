import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/common/widgets/cupertino_button.dart';
import 'package:fly_chatting_app/common/widgets/cupertino_icon_button.dart';
import 'package:fly_chatting_app/common/widgets/messenger_scaffold.dart';
import 'package:fly_chatting_app/common/widgets/text_field.dart';
import 'package:fly_chatting_app/common/widgets/theme/colors_style.dart';
import 'package:fly_chatting_app/home/home_screen.dart';
import 'package:fly_chatting_app/common/local_db/local_db.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.firebaseUser, this.userModel});

  final User? firebaseUser;
  final UserModel? userModel;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  File? profilePicture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Fill Your Profile',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundColor: AppColors.lightDimBlueColor,
                        backgroundImage: (profilePicture == null)
                            ? null
                            : FileImage(profilePicture!),
                        // child: Image(
                        // image: (profilePicture != null)? null: AssetImage("assets/icons/person_2.png"),
                        // color: lightBlueColor,
                        // height: 500,
                      ),
                      // Icon(Icons.person, size: 140, color: lightBlueColor),
                      // ),
                      Positioned(
                        bottom: -7,
                        right: -7,
                        child: CupertinoButton(
                          onPressed: () {
                            showDialogWithProfilePicture();
                          },
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: AppColors.darkBlueColor,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  BuildTextField(
                    textInputAction: TextInputAction.next,
                    controller: _fullNameController,
                    hintText: 'Full Name',
                  ),
                  const SizedBox(height: 25),
                  BuildTextField(
                    textInputAction: TextInputAction.done,
                    controller: _aboutController,
                    hintText: 'About',
                  ),
                  const SizedBox(height: 25),
                  BuildCupertinoButton(
                    onPressed: () {
                      checkValue();
                    },
                    title: 'Register',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showDialogWithProfilePicture() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          title: Row(
            children: const [
              SizedBox(width: 14),
              Text(
                'Select Profile Picture',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Row(
            children: [
              BuildCupertinoButtonIcon(
                onPressed: () {
                  Navigator.of(context).pop();
                  selectedImage(ImageSource.gallery);
                },
                title: 'Gallery',
                icons: Icons.image,
                color: Colors.blue,
              ),
              BuildCupertinoButtonIcon(
                onPressed: () {
                  Navigator.of(context).pop();
                  selectedImage(ImageSource.camera);
                },
                title: 'Camera',
                icons: Icons.camera_alt,
                color: Colors.pink,
              ),
              BuildCupertinoButtonIcon(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    profilePicture = null;
                  });
                },
                title: 'Delete',
                icons: Icons.delete,
                color: Colors.red,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> selectedImage(ImageSource source) async {
    XFile? selectImage = await ImagePicker().pickImage(source: source);
    if (selectImage != null) {
      croppedImage(selectImage);
    }
  }

  Future<void> croppedImage(XFile file) async {
    CroppedFile? cropImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressQuality: 40,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );
    setState(() {
      profilePicture = File(cropImage!.path);
    });
  }

  void checkValue() {
    final String fullName = _fullNameController.text.trim();
    final String about = _aboutController.text.trim();
    if (profilePicture == null || fullName == '' || about == '') {
      Messenger().messengerScaffold(
        text: 'Please fill all the fields',
        context: context,
      );
    } else {
      uploadImages();
    }
  }

  Future<void> uploadImages() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref('profilePictures')
        .child(widget.userModel!.uid.toString())
        .putFile(profilePicture!);

    final String imageUrl = await uploadTask.snapshot.ref.getDownloadURL();
    final String fullName = _fullNameController.text.trim();
    final String about = _aboutController.text.trim();

    widget.userModel!.profilePicture = imageUrl;
    widget.userModel!.fullName = fullName;
    widget.userModel!.about = about;

    setState(() {
      sharedPref.uid = widget.userModel!.uid;
      sharedPref.fullName = fullName;
      sharedPref.phoneNumber = widget.userModel!.phoneNumber.toString();
      sharedPref.profilePicture = imageUrl;
      sharedPref.about = about;
      log('------------------------------------- data added --------------------------------------');
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userModel!.uid)
        .set(widget.userModel!.toJson())
        .then((value) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen(),), (route) => false);
    });
  }
}
