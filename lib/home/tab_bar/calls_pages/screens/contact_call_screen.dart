// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/home/tab_bar/calls_pages/provider/calls_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/provider/chat_&_message_provider.dart';
import 'package:fly_chatting_app/models/call_model.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/provider/contact_service_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ContactCallScreen extends StatefulWidget {
  const ContactCallScreen({Key? key}) : super(key: key);

  @override
  State<ContactCallScreen> createState() => _ContactCallScreenState();
}

class _ContactCallScreenState extends State<ContactCallScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Contact',
              style: TextStyle(fontFamily: "Rounded Bold", fontSize: 18),
            ),
            Text(
              '${context.read<ContactProvider>().firebaseContact.length} contacts',
              style: const TextStyle(fontSize: 13, fontFamily: "Rounded Bold"),
            )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 16, right: 18, left: 18, bottom: 16),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
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
                    borderSide: BorderSide(width: 1.6, color: Colors.blue),
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
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(.06)),
            ),
          ),
          FutureBuilder<List<UserModel>>(
            future: context.watch<ContactProvider>().getFirebaseContacts(),
            builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              } else {
                if (snapshot.hasData) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        // isSearching == true ? fireContacts.length :
                        snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var contact =
                          // isSearching == true ? fireContacts[index] :
                          snapshot.data![index];


                      return ListTile(
                        contentPadding:
                            const EdgeInsets.only(left: 18, right: 10),
                        onTap: () async {},
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
                            ),
                          ],
                        ),
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.grey.withOpacity(.40),
                          backgroundImage: contact.profilePicture != null
                              ? NetworkImage(contact.profilePicture.toString())
                              : null,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CupertinoButton(
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(Icons.call),
                              onPressed: ()async {
                              },
                            ),
                            CupertinoButton(
                              padding: const EdgeInsets.only(right: 24),
                              child:
                                  const Icon(Icons.videocam_rounded, size: 27),
                              onPressed: () async {
                                // UserModel receiverData = UserModel(
                                //     phoneNumber: contact.phoneNumber,
                                //     uid: contact.uid,
                                //     fullName: contact.fullName,
                                //     profilePicture: contact.profilePicture,
                                //     about: contact.about);
                                //
                                // final userData = await context
                                //     .read<ChatProvider>()
                                //     .userData(
                                //         uid: FirebaseAuth
                                //             .instance.currentUser!.uid);
                                // String channelId = Uuid().v1();
                                //
                                // CallModel call = CallModel(
                                //     callerId: userData!.uid,
                                //     callerName: userData.fullName,
                                //     callerPic: userData.profilePicture!,
                                //     receiverId: receiverData.uid,
                                //     receiverName: receiverData.fullName,
                                //     receiverPic: receiverData.profilePicture!,
                                //     channelId: channelId,
                                //     hasDialled: true);
                                //
                                // var data =  context
                                //     .read<CallProvider>()
                                //     .makeCall(call: call);
                              },
                            ),
                          ],
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
        ],
      ),
    );
  }
}
