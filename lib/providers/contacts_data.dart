import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:fly_chatting_app/models/user_model.dart';

class ContactData with ChangeNotifier{
  final List<UserModel> firebaseContacts = [];
  final List<UserModel> phoneContacts = [];

  List<String> names = [];
  List<String> numbers = [];
  List<Uint8List?> images = [];
  List<String> nameFirst = [];

  Future<void> getAllContactss() async {

    final getFirebaseContacts =
    await FirebaseFirestore.instance.collection('users').get();
    final getPhoneContacts =
    await ContactsService.getContacts(withThumbnails: false);

    bool isContactFound = false;

    for (final contact in getPhoneContacts) {

      contact.phones!.toSet().forEach((phone) {
        names.add(contact.displayName!);
        numbers.add(contact.phones![0].value!);
        images.add(contact.avatar);
        nameFirst.add(contact.displayName![0]);
      });

      for (final fireStoreContactData in getFirebaseContacts.docs) {
        final firebaseContact = UserModel.fromMap(fireStoreContactData.data());
        if (numbers[0]
            .replaceAll(' ', '')
            .replaceAll('-', '')
            .replaceAll('+91', '')
            .replaceAll('+261', '') ==
            firebaseContact.phoneNumber) {
          firebaseContacts.add(firebaseContact);
          isContactFound = true;
          break;
        }
      }
      if (!isContactFound) {
        phoneContacts.add(
          UserModel(
            about: '',
            fullName: names.toString(),
            phoneNumber: numbers[0]
                .replaceAll(' ', '')
                .replaceAll('-', '')
                .replaceAll('+91', '')
                .replaceAll('+261', ''),
            profilePicture: nameFirst.toString(),
            uid: '',
          ),
        );
      }
      isContactFound = false;

    }

  }
}