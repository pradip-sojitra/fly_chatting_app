// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/providers/contacts_provider.dart';
import 'package:fly_chatting_app/widgets/contact_list.dart';
import 'package:fly_chatting_app/widgets/theme/colors_style.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<String> names = [];
  List<String> numbers = [];
  List<Uint8List?> images = [];
  List<String> nameFirst = [];

  @override
  void initState() {
    getContactPermission();
    super.initState();
  }

  Future<void> getContactPermission() async {
    if (await Permission.contacts.isGranted) {
      await getAllContacts();
    } else {
      await Permission.contacts.request();
    }
  }

  Future<void> getAllContacts() async {
    final contactsAll =
        await ContactsService.getContacts(withThumbnails: false);

    for (final contact in contactsAll) {
      contact.phones!.toSet().forEach((phone) {
        names.add(contact.displayName!);
        numbers.add(contact.phones![0].value!);
        images.add(contact.avatar);
        nameFirst.add(contact.displayName![0]);
      });
    }
    context.read<ContactSearchProvider>().isLoadingChange();
  }


  @override
  Widget build(BuildContext context) {
    log('build_ContactScreen');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 28,
          ),
        ),
        title: const Text(
          'Contacts',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        elevation: 0,
      ),
      body: context.watch<ContactSearchProvider>().isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.darkBlueColor))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 16,
                    left: 16,
                    top: 10,
                    bottom: 8,
                  ),
                  child: TextFormField(
                    controller:
                        context.read<ContactSearchProvider>().searchController,
                    onChanged: (value) {
                      context.read<ContactSearchProvider>().changedValue(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 16,
                      ),
                      prefixIcon: IconButton(
                        onPressed: () {

                        },
                        icon: const Icon(
                          Icons.search,
                          color: AppColors.darkBlueColor,
                          size: 32,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          context.read<ContactSearchProvider>().clearSearch();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.darkBlueColor,
                          size: 28,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(
                            color: AppColors.darkBlueColor, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(
                            color: AppColors.darkBlueColor, width: 2),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: numbers.length,
                    itemBuilder: (context, index) {
                      if (names[index].toLowerCase().contains(context
                              .read<ContactSearchProvider>()
                              .isSearching
                              .toLowerCase()) ||
                          numbers[index].contains(context
                              .read<ContactSearchProvider>()
                              .isSearching
                              .toLowerCase())) {
                        return ContactList(
                            index: index,
                            images: images,
                            nameFirst: nameFirst,
                            names: names,
                            numbers: numbers);
                      }
                      if (context
                              .read<ContactSearchProvider>()
                              .searchController
                              .text ==
                          '') {
                        return ContactList(
                            index: index,
                            images: images,
                            nameFirst: nameFirst,
                            names: names,
                            numbers: numbers);
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
//
// Future<void> getAllContacts() async {
//   final List<UserModel> firebaseContacts = [];
//   final List<UserModel> phoneContacts = [];
//
//   final userCollection =
//       await FirebaseFirestore.instance.collection('users').get();
//   final getContactsInThePhone = await ContactsService.getContacts();
//
//   var isContactFound = false;
//
//   for (final contact in getContactsInThePhone) {
//     for (final fireStoreContactData in userCollection.docs) {
//       final firebaseContact = UserModel.fromMap(fireStoreContactData.data());
//       String isCheckNumber = contact.phones![0].value!
//           .replaceAll(' ', '')
//           .replaceAll('-', '')
//           .replaceAll('+91', '')
//           .replaceAll('+261', '');
//       if (isCheckNumber == firebaseContact.phoneNumber) {
//         firebaseContacts.add(firebaseContact);
//         isContactFound = true;
//         break;
//       }
//     }
//     if (!isContactFound) {
//       phoneContacts.add(
//         UserModel(
//           about: '',
//           fullName: contact.displayName,
//           phoneNumber: contact.phones![0].value!
//               .replaceAll(' ', '')
//               .replaceAll('-', '')
//               .replaceAll('+91', '')
//               .replaceAll('+261', ''),
//           profilePicture: '',
//           uid: '',
//         ),
//       );
//     }
//     isContactFound = false;
//   }
// }
