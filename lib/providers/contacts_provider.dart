import 'dart:typed_data';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactSearchProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  String isSearching = '';
  bool isLoading = true;

  List<String> names = [];
  List<String> numbers = [];
  List<Uint8List?> images = [];
  List<String> nameFirst = [];

  void clearSearch() {
    searchController.clear();
    notifyListeners();
  }


  void changedValue(String value) {
    isSearching = value;
    notifyListeners();
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
    isLoadingChange();
  }

  void isLoadingChange(){
    isLoading = false;
    notifyListeners();
  }

}
