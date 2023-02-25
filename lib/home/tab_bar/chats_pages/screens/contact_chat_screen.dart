// ignore_for_file: use_build_context_synchronously

/*

import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/common/widgets/cupertino_text_button.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/provider/chat_&_message_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/provider/contact_service_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactChatScreen extends StatefulWidget {
  const ContactChatScreen({Key? key}) : super(key: key);

  @override
  State<ContactChatScreen> createState() => _ContactChatScreenState();
}

class _ContactChatScreenState extends State<ContactChatScreen> {
  void getContactPermission() async {
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

  void selectedContact(UserModel receiverData) {
    context
        .read<ChatProvider>()
        .selectContact(context: context, receiverAllData: receiverData);
  }

  @override
  void initState() {
    super.initState();
    getContactPermission();
    context.read<ContactProvider>().searchController.addListener(() {
      context.read<ContactProvider>().filterContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching =
        context.watch<ContactProvider>().searchController.text.isNotEmpty;
    log('Build ContactScreen');
    return Scaffold(
      appBar: !context.watch<ContactProvider>().searchView
          ? AppBar(
              elevation: 0.0,
              automaticallyImplyLeading: false,
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 26,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Contact',
                    style: TextStyle(fontFamily: "Rounded Bold", fontSize: 18),
                  ),
                  Text(
                    '${context.read<ContactProvider>().firebaseContact.length + context.read<ContactProvider>().phoneContact.length} contacts',
                    style: const TextStyle(
                        fontSize: 13, fontFamily: "Rounded Bold"),
                  )
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<ContactProvider>().searchAlwaysChange();
                  },
                  icon: const Image(
                    image: AssetImage('assets/icons/search.png'),
                    height: 20,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            )
          : AppBar(
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: 26,
                ),
                onPressed: () {
                  context.read<ContactProvider>().searchChange(false);
                  context.read<ContactProvider>().clearSearch();
                },
              ),
              actions: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(
                    Icons.clear,
                    color: Colors.black,
                    size: 26,
                  ),
                  onPressed: () =>
                      context.read<ContactProvider>().clearSearch(),
                ),
                const SizedBox(width: 10),
              ],
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: TextFormField(
                cursorColor: Colors.blue,
                controller: context.read<ContactProvider>().searchController,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: isSearching
                ? null
                : const Text(
                    'Contacts on FlyChat',
                    style: TextStyle(
                        fontFamily: 'Rounded Bold',
                        fontSize: 16,
                        color: Colors.black54),
                  ),
          ),
          FutureBuilder<List<UserModel>>(
            future: context.read<ContactProvider>().getFirebaseContacts(),
            builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else {
                if (snapshot.hasData) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: isSearching == true
                        ? context.read<ContactProvider>().fireContacts.length
                        : snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var contact = isSearching == true
                          ? context.read<ContactProvider>().fireContacts[index]
                          : snapshot.data![index];
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.only(left: 18, right: 10),
                        onTap: () {
                          selectedContact(contact);
                        },
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(contact.fullName.toString(),
                                style: const TextStyle(
                                    fontFamily: 'Rounded ExtraBold')),
                            Text(
                              contact.about.toString(),
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
                          backgroundImage: contact.profilePicture != null
                              ? NetworkImage(contact.profilePicture.toString())
                              : null,
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('No have a Data'),
                  );
                }
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: isSearching
                ? null
                : const Text(
                    'Invite to FlyChat',
                    style: TextStyle(
                        fontFamily: 'Rounded Bold',
                        fontSize: 16,
                        color: Colors.black54),
                  ),
          ),
          Flexible(
            child: FutureBuilder<List<UserModel?>>(
              future: context.read<ContactProvider>().getPhoneInvite(),
              builder: (context, AsyncSnapshot<List<UserModel?>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: isSearching == true
                          ? context
                              .read<ContactProvider>()
                              .contactFiltered
                              .length
                          : snapshot.data?.length,
                      itemBuilder: (context, index) {
                        var contact = isSearching == true
                            ? context
                                .read<ContactProvider>()
                                .contactFiltered[index]
                            : snapshot.data![index];
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.only(left: 18, right: 10),
                          onTap: () {
                            String num = contact.phoneNumber.toString();
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
                              String num = contact.phoneNumber.toString();
                              _launchURL(num);
                            },
                            title: 'Invite',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 0.8,
                                color: Theme.of(context)
                                    .appBarTheme
                                    .backgroundColor,
                                fontFamily: "Varela Round Regular"),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No have a data!'),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/common/widgets/cupertino_text_button.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/provider/chat_&_message_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/provider/contact_service_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/utils/show_profile.dart';
import 'package:fly_chatting_app/models/chat_list_model.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactChatScreen extends StatelessWidget {
  const ContactChatScreen({super.key});

  _launchURL({required String phoneNumber}) async {
    print('-------- $phoneNumber hii ---------');

    final String url =
        "sms: $phoneNumber ?body=Let's chat on FlyChat! it's a fast, simple, and secure app we can call each other for free.";
    var sms = Uri.parse(url);
    if (await canLaunchUrl(sms)) {
      await launchUrl(sms);
    } else {
      throw 'Could not launch $url';
    }
  }

  void selectedContact(
      {required BuildContext context, required UserModel receiverData}) {
    context
        .read<ChatProvider>()
        .selectContact(context: context, receiverAllData: receiverData);
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching =
        context.watch<ContactProvider>().searchController.text.isNotEmpty;
    print('Build ContactScreen');
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 26,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Contact',
                style: TextStyle(fontFamily: "Rounded Bold", fontSize: 18),
              ),
              FutureBuilder(
                  future: context.read<ContactProvider>().getAllContacts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        "counting...",
                        style:
                            TextStyle(fontSize: 13, fontFamily: "Rounded Bold"),
                      );
                    }
                    return Text(
                      "${snapshot.data![0].length + snapshot.data![1].length} Contacts",
                      style: const TextStyle(
                          fontSize: 13, fontFamily: "Rounded Bold"),
                    );
                  })
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.read<ContactProvider>().searchAlwaysChange();
              },
              icon: const Image(
                image: AssetImage('assets/icons/search.png'),
                height: 20,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: FutureBuilder(
          future: context.read<ContactProvider>().getAllContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data![0].length + snapshot.data![1].length,
              itemBuilder: (context, index) {
                late UserModel firebaseContacts;
                late UserModel phoneContacts;

                if (index < snapshot.data![0].length) {
                  firebaseContacts = snapshot.data![0][index];
                } else {
                  phoneContacts =
                      snapshot.data![1][index - snapshot.data![0].length];
                }
                return index < snapshot.data![0].length
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text(
                                'Contacts on FlyChat',
                                style: TextStyle(
                                    fontFamily: 'Rounded Black',
                                    fontSize: 16,
                                    color: Colors.blue),
                              ),
                            ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.only(left: 18, right: 10),
                            onTap: () {
                              selectedContact(
                                  context: context,
                                  receiverData: firebaseContacts);
                            },
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(firebaseContacts.fullName,
                                    style: const TextStyle(
                                        fontFamily: 'Rounded ExtraBold')),
                                Text(
                                  firebaseContacts.about.toString(),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      fontFamily: 'Rounded ExtraBold'),
                                )
                              ],
                            ),
                            leading: CupertinoButton(
                              onPressed: () async {
                                var receiverDataFireStore =
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .collection('chats')
                                        .doc(firebaseContacts.uid)
                                        .get();

                                ChatListModel receiverData =
                                    ChatListModel.fromJson(
                                        receiverDataFireStore.data()!);

                                showProfileSmall(
                                    context: context, chatList: receiverData);
                              },
                              padding: EdgeInsets.zero,
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.grey.withOpacity(.40),
                                backgroundImage:
                                    firebaseContacts.profilePicture != null
                                        ? NetworkImage(firebaseContacts
                                            .profilePicture
                                            .toString())
                                        : null,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == snapshot.data![0].length)
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text(
                                'Invite to FlyChat',
                                style: TextStyle(
                                    fontFamily: 'Rounded Black',
                                    fontSize: 16,
                                    color: Colors.blue),
                              ),
                            ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.only(left: 18, right: 10),
                            onTap: () {
                              String phoneNumber = phoneContacts.phoneNumber;
                              _launchURL(phoneNumber: phoneNumber);
                            },
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(phoneContacts.fullName,
                                    style: const TextStyle(
                                      fontFamily: 'Rounded ExtraBold',
                                      fontSize: 15,
                                    )),
                                Text(
                                  phoneContacts.phoneNumber,
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
                                String phoneNumber =
                                    phoneContacts.phoneNumber.toString();
                                _launchURL(phoneNumber: phoneNumber);
                              },
                              title: 'Invite',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 0.8,
                                  color:Colors.blue,
                                  fontFamily: "Varela Round Regular"),
                            ),
                          ),
                        ],
                      );
              },
            );
          },
        ));
  }
}
