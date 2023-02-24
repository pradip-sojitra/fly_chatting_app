import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fly_chatting_app/common/widgets/messenger_scaffold.dart';
import 'package:image_picker/image_picker.dart';

class CommonFirebaseStorageProvider extends ChangeNotifier {
  Future<File?> selectedImage(BuildContext context, ImageSource source) async {
    File? image;
    try {
      XFile? selectImage = await ImagePicker().pickImage(source: source);

      if (selectImage != null) {
        image = File(selectImage.path);
      }
    } catch (e) {
      Messenger().messengerScaffold(text: e.toString(), context: context);
    }
    return image;
  }

  Future<File?> selectedVideo(BuildContext context, ImageSource source) async {
    File? video;
    try {
      XFile? selectVideo = await ImagePicker().pickVideo(source: source);

      if (selectVideo != null) {
        video = File(selectVideo.path);
      }
    } catch (e) {
      Messenger().messengerScaffold(text: e.toString(), context: context);
    }
    return video;
  }

  Future<String> storeFileToFirebase(String fileName, File file) async {
    UploadTask uploadTask =
        FirebaseStorage.instance.ref().child(fileName).putFile(file);

    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
