import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/models/chats_check_participant_model.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/widgets/theme/colors_style.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactScreen extends StatefulWidget {
  ContactScreen({
    super.key,
    required this.firebaseUser,
    required this.userModel,
  });

  User firebaseUser;
  UserModel userModel;

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  TextEditingController searchController = TextEditingController();
  List<Contact> contacts = [];
  bool isLoading = true;
  String isSearching = '';

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
    setState(() {
      contacts = contactsAll;
    });
    setState(() {
      isLoading = false;
    });
  }

  Future<ChatCheckParticipant?> getParticipantChat(UserModel targetUser) async {
    ChatCheckParticipant? chatCheckData;

    final checkTargetChat = await FirebaseFirestore.instance
        .collection('chatCheck')
        .where('participant.${widget.userModel.uid}', isEqualTo: true)
        .where('participant.${targetUser.uid}', isEqualTo: true)
        .get();

    if (checkTargetChat.docs.isNotEmpty) {
      final getChatData = checkTargetChat.docs[0].data();
      ChatCheckParticipant existsParticipant =
          ChatCheckParticipant.fromMap(getChatData);

      chatCheckData = existsParticipant;
      log('chat is exists');
    } else {
      ChatCheckParticipant newChatData = ChatCheckParticipant(
        chatId: targetUser.phoneNumber,
        lastMessage: '',
        participant: {
          widget.userModel.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection('chatCheck')
          .doc(newChatData.chatId)
          .set(newChatData.toMap());

      chatCheckData = newChatData;
      log('new chatScreen is created');
    }
  }

  // List<UserModel> firebaseAllContacts = [];
  // List<UserModel> phoneAllContacts = [];

  // Future<void> getAllContacts() async {
  //   final List<UserModel> firebaseContacts = [];
  //   final List<UserModel> phoneContacts = [];
  //
  //   firebaseAllContacts = firebaseContacts;
  //   phoneAllContacts = phoneContacts;
  //
  //   if (await FlutterContacts.requestPermission()) {
  //     final userCollection = await FirebaseFirestore.instance.collection('users').get();
  //     final getContactsInThePhone = await FlutterContacts.getContacts(withThumbnail: true);
  //
  //     var isContactFound = false;
  //
  //     for (final contact in getContactsInThePhone) {
  //       for (final fireStoreContactData in userCollection.docs) {
  //         final firebaseContact = UserModel.fromJson(fireStoreContactData.data() as Map<String, String>);
  //         if (contact.phones[0].number
  //             .replaceAll(' ', '')
  //             .replaceAll('-', '')
  //             .replaceAll('+91', '')
  //             .replaceAll('+261', '') ==
  //             firebaseContact.phoneNumber) {
  //           firebaseContacts.add(firebaseContact);
  //           isContactFound = true;
  //           break;
  //         }
  //       }
  //       if (!isContactFound) {
  //         phoneContacts.add(
  //           UserModel(
  //             about: '',
  //             firstName: contact.displayName,
  //             lastName: '',
  //             phoneNumber: contact.phones[0].number
  //                 .replaceAll(' ', '')
  //                 .replaceAll('-', '')
  //                 .replaceAll('+91', '')
  //                 .replaceAll('+261', ''),
  //             profilePicture: '',
  //             uid: '',
  //           ),
  //         );
  //       }
  //       isContactFound = false;
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: darkBlueColor))
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
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        isSearching = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 16,
                      ),
                      prefixIcon: IconButton(
                        onPressed: () {
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.search,
                          color: darkBlueColor,
                          size: 32,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            searchController.clear();
                          });
                        },
                        icon: const Icon(
                          Icons.close,
                          color: darkBlueColor,
                          size: 28,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide:
                            const BorderSide(color: darkBlueColor, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide:
                            const BorderSide(color: darkBlueColor, width: 2),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: numbers.length,
                    itemBuilder: (context, index) {
                      if (names[index]
                              .toLowerCase()
                              .startsWith(isSearching.toLowerCase()) ||
                          numbers[index]
                              .startsWith(isSearching.toLowerCase())) {
                        return contactsAllData(index);
                      }
                      if (searchController.text == '') {
                        return contactsAllData(index);
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget contactsAllData(int index) {
    final isCheckImage = images[index]!.isNotEmpty;
    return ListTile(
      onTap: () async {
        final number = numbers[index]
            .replaceAll('-', '')
            .replaceAll(' ', '')
            .replaceAll('+91', '')
            .replaceAll('+261', '');

        final targetData = await FirebaseFirestore.instance
            .collection('users')
            .where('phoneNumber', isEqualTo: number)
            .get();
        final dataAll = targetData.docs[0].data();
        UserModel targetUser = UserModel.fromMap(dataAll);

        log('---------------------local-----------------------$number----------------------------------------------------');
        log('---------------------fireStoreData-----------------------${targetUser.uid.toString()}---------------------------');

        ChatCheckParticipant? chatCheck = await getParticipantChat(targetUser);

        // Navigator.of(context).pop();
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => ChatScreen(
        //       firebaseUser: widget.firebaseUser,
        //       userModel: widget.userModel,
        //       targetUser: targetUser,
        //       // chatCheck: ,
        //       contactImages: images[index],
        //       contactNameFirst: nameFirst[index],
        //       contactName: names[index],
        //       contactNumbers: number,
        //     ),
        //   ),
        // );
      },
      title: Text(names[index]),
      subtitle: Text(numbers[index]),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: lightBlueColor.withOpacity(0.8),
        backgroundImage: isCheckImage ? MemoryImage(images[index]!) : null,
        child: Center(
          child: isCheckImage
              ? null
              : Text(
                  nameFirst[index].toUpperCase(),
                  style: const TextStyle(fontSize: 22, color: Colors.black),
                ),
        ),
      ),
    );
  }
}
