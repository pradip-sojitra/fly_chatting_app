// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/models/chats_check_participant_model.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/providers/contacts_provider.dart';
import 'package:fly_chatting_app/screens/ChatScreen.dart';
import 'package:fly_chatting_app/widgets/theme/colors_style.dart';
import 'package:provider/provider.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({
    super.key,
    required this.firebaseUser,
    required this.userModel,
  });

  final User firebaseUser;
  final UserModel userModel;

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  void initState() {
    context.read<ContactSearchProvider>().getContactPermission();
    super.initState();
  }

  Future<ChatCheckModel?> getParticipantChat(UserModel targetUser) async {
    ChatCheckModel? chatCheckData;

    final checkTargetChat = await FirebaseFirestore.instance
        .collection('chatCheck')
        .where('participant.${widget.userModel.uid}', isEqualTo: true)
        .where('participant.${targetUser.uid}', isEqualTo: true)
        .get();

    if (checkTargetChat.docs.isNotEmpty) {
      final getChatData = checkTargetChat.docs[0].data();
      ChatCheckModel existsParticipant = ChatCheckModel.fromMap(getChatData);

      chatCheckData = existsParticipant;
      log('chat is exists');
    } else {
      final String chatId = DateTime.now().microsecondsSinceEpoch.toString();
      ChatCheckModel newChatData = ChatCheckModel(
        chatId: chatId,
        lastMessage: '',
        lastTime: '',
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
    return chatCheckData;
  }

  @override
  Widget build(BuildContext context) {
    print('build');
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
                        onPressed: () {},
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
                  child: Consumer<ContactSearchProvider>(
                    builder: (context, value, child) {
                      return ListView.builder(
                        itemCount: value.numbers.length,
                        itemBuilder: (context, index) {
                          if (value.names[index].toLowerCase().startsWith(
                                  value.isSearching.toLowerCase()) ||
                              value.numbers[index].startsWith(
                                  value.isSearching.toLowerCase())) {
                            return contactsAllData(index);
                          }
                          if (value.searchController.text == '') {
                            return contactsAllData(index);
                          }
                          return Container();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget contactsAllData(int index) {
    return Consumer<ContactSearchProvider>(
      builder: (context, value, child) {
        final isCheckImage = value.images[index]!.isNotEmpty;
        return ListTile(
          onTap: () async {
            final number = value.numbers[index]
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
            log('---------------------fireStoreData-----------------------${targetUser.fullName} ${targetUser.phoneNumber}---------------------------');

            ChatCheckModel? chatCheck = await getParticipantChat(targetUser);

            if (chatCheck != null) {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    firebaseUser: widget.firebaseUser,
                    userModel: widget.userModel,
                    targetUser: targetUser,
                    chatCheck: chatCheck,
                  ),
                ),
              );
            }
          },
          title: Text(value.names[index]),
          subtitle: Text(value.numbers[index]),
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.lightBlueColor.withOpacity(0.8),
            backgroundImage:
                isCheckImage ? MemoryImage(value.images[index]!) : null,
            child: Center(
              child: isCheckImage
                  ? null
                  : Text(
                      value.nameFirst[index].toUpperCase(),
                      style: const TextStyle(fontSize: 22, color: Colors.black),
                    ),
            ),
          ),
        );
      },
    );
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
