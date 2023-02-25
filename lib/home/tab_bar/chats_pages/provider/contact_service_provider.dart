import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fly_chatting_app/common/local_db/local_db.dart';
import 'package:fly_chatting_app/models/user_model.dart';

class ContactProvider with ChangeNotifier {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController searchController = TextEditingController();
  List<UserModel?> contactFiltered = [];
  List<UserModel> fireContacts = [];
  bool searchView = false;
  bool value = true;

  List<UserModel> firebaseContact = [];
  List<UserModel?> phoneContact = [];
  List<Contact> contacts = [];

  Future<List<List<UserModel>>> getAllContacts() async {
    List<UserModel> firebaseContacts = [];
    List<UserModel> phoneContacts = [];

    try {
      if (await FlutterContacts.requestPermission()) {
        final userCollection = await fireStore.collection('users').get();
        List<Contact> allContactsInThePhone =
            await FlutterContacts.getContacts(withProperties: true);
        List<UserModel?> contact =
            allContactsInThePhone.map((e) => convertContactModel(e)).toList();
        contact.removeWhere((element) => element == null);

        bool isContactFound = false;

        for (var contact in contact) {
          for (var firebaseContactData in userCollection.docs) {
            var firebaseContact =
                UserModel.fromJson(firebaseContactData.data());

            if (contact!.phoneNumber
                    .replaceAll(' ', '')
                    .replaceAll('-', '')
                    .replaceAll('+91', '') ==
                firebaseContact.phoneNumber) {
              firebaseContacts.add(firebaseContact);
              firebaseContacts.removeWhere(
                  (element) => element.uid == auth.currentUser!.uid);
              isContactFound = true;
              break;
            }
          }
          if (!isContactFound) {
            phoneContacts.add(
              UserModel(
                  fullName: contact!.fullName,
                  uid: '',
                  phoneNumber: contact.phoneNumber),
            );
          }

          isContactFound = false;
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return [firebaseContacts, phoneContacts];
  }

  UserModel? convertContactModel(Contact contact) {
    try {
      return UserModel(
        uid: '',
        phoneNumber: contact.phones[0].number,
        fullName: contact.displayName,
      );
    } catch (e) {
      return null;
    }
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

    // for (var value in firebaseContact) {
    //   temp.remove(value);
    // }

    temp.removeWhere((element) => element == null);
    phoneContact = temp;
    return temp;
  }

  Future<List<UserModel?>> phoneContactsAll() async {
    final temp = contacts.map((e) => convertContactModel(e)).toList();
    temp.removeWhere((element) => element == null);
    return temp;
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
