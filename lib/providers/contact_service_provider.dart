import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:fly_chatting_app/models/local_db.dart';
import 'package:fly_chatting_app/models/user_model.dart';

class ContactProvider with ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  List<UserModel?> contactFiltered = [];
  List<UserModel> fireContacts = [];
  bool searchView = false;
  bool value = true;

  List<UserModel> firebaseContact = [];
  List<UserModel?> phoneContact = [];
  List<Contact> contacts = [];

  Future<List<Contact>> getPhoneContacts() async {
    final allContactsInThePhone =
        await ContactsService.getContacts(withThumbnails: false);
    contacts = allContactsInThePhone;
    return allContactsInThePhone;
  }

  Future<List<UserModel>> getFirebaseContacts() async {
    final usersData =
        await FirebaseFirestore.instance.collection('users').get();

    firebaseContact = usersData.docs
        .map(
          (e) => UserModel(
            uid: e.id,
            fullName: e.data()['fullName'],
            profilePicture: e.data()['profilePicture'],
            phoneNumber: e.data()['phoneNumber'],
            about: e.data()['about'],
          ),
        )
        .toList();
    firebaseContact.removeWhere((element) => element.uid == sharedPref.uid);
    return firebaseContact;
  }

  Future<List<UserModel?>> getPhoneInvite() async {
    final temp = contacts.map((e) => convertContactModel(e)).toList();

    for (var value in firebaseContact) {
      temp.remove(value);
    }

    temp.removeWhere((element) => element == null);
    phoneContact = temp;
    return temp;
  }

  UserModel? convertContactModel(Contact contact) {
    try {
      return UserModel(
        uid: '',
        phoneNumber: contact.phones!.first.value ?? 'Invalid Phone',
        fullName: contact.displayName ?? 'User',
      );
    } catch (e) {
      return null;
    }
  }

  void clearSearch() {
    searchController.clear();
    notifyListeners();
  }

  void searchAlwaysChange() {
    searchView = !searchView;
    notifyListeners();
  }

  void searchChange(bool value) {
    searchView = value;
    notifyListeners();
  }

  filterContacts() {
    List<UserModel?> contact = [];
    List<UserModel> firebaseContacts = [];
    contact.addAll(phoneContact);
    firebaseContacts.addAll(firebaseContact);
    if (searchController.text.isNotEmpty) {
      contact.retainWhere((contact) {
        String contacts = contact.toString().toLowerCase();
        return contacts.contains(searchController.text.toLowerCase());
      });
      firebaseContacts.retainWhere((contact) {
        String contacts = contact.toString().toLowerCase();
        return contacts.contains(searchController.text.toLowerCase());
      });
      contactFiltered = contact;
      fireContacts = firebaseContacts;
      notifyListeners();
    }
  }
}

// String? cleanPhone(String number) {
//   final cleaned =
//       number.replaceAll(" ", '').replaceAll("+91", '').replaceAll("-", "");
//   if (cleaned.length == 10) {
//     return cleaned;
//   }
//   return null;
// }
