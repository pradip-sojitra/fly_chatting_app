// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/models/chats_check_participant_model.dart';
import 'package:fly_chatting_app/models/firebase_data.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/providers/contact_service_provider.dart';
import 'package:fly_chatting_app/providers/search_provider.dart';
import 'package:fly_chatting_app/screens/ChatScreen.dart';
import 'package:fly_chatting_app/widgets/cupertino_text_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  Future<void> getContactPermission() async {
    if (await Permission.contacts.isGranted) {
      await context.read<ContactProvider>().getPhoneContacts();
    } else {
      await Permission.contacts.request();
    }
  }

  _launchURL(String num) async {
    log('-------- $num hii ---------');

    final String url = 'sms: $num ?body=hello%20there';
    var uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  TextEditingController searchController = TextEditingController();
  String search = '';

  @override
  void initState() {
    getContactPermission();
    searchController.addListener(() {
      filterContacts();
    });
    super.initState();
  }

  List<UserModel?> contactFiltered = [];

  void filterContacts() {
    List<UserModel?> _contact = [];
    _contact.addAll(context.read<ContactProvider>().temps);
    if (search.toString().isNotEmpty) {
      _contact.retainWhere((contact) {
        String contactName = contact!.fullName.toString().toLowerCase();
        return contactName.contains(search.toString().toLowerCase());
      });
    }
    setState(() {
      contactFiltered = _contact;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = search.isNotEmpty;
    log('Build ContactScreen');
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Contact',
              style: TextStyle(fontFamily: "Rounded Bold", fontSize: 18),
            ),
            Text(
              '${context.read<ContactProvider>().firebaseContact.length + context.read<ContactProvider>().temps.length} contacts',
              style: const TextStyle(fontSize: 13, fontFamily: "Rounded Bold"),
            )
          ],
        ),
      ),
      body: ListView(children: [
        FutureBuilder(
          future: context.read<ContactProvider>().getFirebaseContacts(),
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 18, left: 18),
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 14),
                        hintText: 'Search',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(23)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1.6, color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(23)),
                        ),
                        prefixIcon: CupertinoButton(
                          child: Image.asset(
                            'assets/icons/search.png',
                            color: Colors.blue,
                            width: 18,
                          ),
                          onPressed: () {},
                        ),
                        suffixIcon: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Icon(
                            Icons.close,
                          ),
                          onPressed: () {
                            setState(() {
                              searchController.clear();
                              search = '';
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(.08)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Contacts on FlyChat',
                    style: TextStyle(
                        fontFamily: 'Rounded Bold',
                        fontSize: 16,
                        color: Colors.black54),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    log('----------------------------------- phone contacts...CONTACT SCREEN -----------------------------------');
                    return ListTile(
                      contentPadding:
                          const EdgeInsets.only(left: 18, right: 10),
                      onTap: () async {
                        final targetData = await FirebaseFirestore.instance
                            .collection('users')
                            .where('phoneNumber',
                                isEqualTo: snapshot.data![index].phoneNumber)
                            .get();

                        UserModel targetUser =
                            UserModel.fromMap(targetData.docs.first.data());
                        ChatCheckModel? chatCheck =
                            await FirebaseData.getParticipantChat(targetUser);

                        if (chatCheck != null) {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                targetUser: targetUser,
                                chatCheck: chatCheck,
                              ),
                            ),
                          );
                        }
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data![index].fullName.toString(),
                              style: const TextStyle(
                                  fontFamily: 'Rounded ExtraBold')),
                          Text(
                            snapshot.data![index].about.toString(),
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                fontFamily: 'Rounded ExtraBold'),
                          )
                        ],
                      ),
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.grey.withOpacity(.40),
                        backgroundImage: snapshot.data![index].profilePicture !=
                                null
                            ? NetworkImage(
                                snapshot.data![index].profilePicture.toString())
                            : null,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
        FutureBuilder<List<UserModel?>>(
          future: context.read<ContactProvider>().getInvite(),
          builder: (context, AsyncSnapshot<List<UserModel?>> snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Invite to FlyChat',
                    style: TextStyle(
                        fontFamily: 'Rounded Bold',
                        fontSize: 16,
                        color: Colors.black54),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: isSearching == true
                      ? contactFiltered.length
                      : snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    log('----------------------------------- phone contacts...CONTACT SCREEN -----------------------------------');
                    var contact = isSearching == true
                        ? contactFiltered[index]
                        : snapshot.data![index];

                    return ListTile(
                      contentPadding:
                          const EdgeInsets.only(left: 18, right: 10),
                      onTap: () {
                        String num = snapshot.data![index]!.phoneNumber;
                        _launchURL(num);
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(contact!.fullName.toString(),
                              style: const TextStyle(
                                fontFamily: 'Rounded ExtraBold',
                                fontSize: 15,
                              )),
                          Text(
                            contact.phoneNumber.toString(),
                            style: const TextStyle(
                                fontSize: 13.5,
                                color: Colors.black54,
                                fontFamily: 'Rounded Bold'),
                          ),
                          const SizedBox(height: 5)
                        ],
                      ),
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.grey.withOpacity(.30),
                        child: Image.asset(
                          'assets/icons/person_2.png',
                          height: 32,
                          color: Colors.white70,
                        ),
                      ),
                      trailing: BuildCupertinoButtonText(
                        onPressed: () {
                          String num = snapshot.data![index]!.phoneNumber;
                          _launchURL(num);
                        },
                        title: 'Invite',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 0.8,
                            color:
                                Theme.of(context).appBarTheme.backgroundColor,
                            fontFamily: "Varela Round Regular"),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ]),
    );
  }
}
