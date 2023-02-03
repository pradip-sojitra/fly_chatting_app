// // // ignore_for_file: use_build_context_synchronously
// //
// // import 'dart:developer';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:fly_chatting_app/models/chats_check_participant_model.dart';
// // import 'package:fly_chatting_app/models/firebase_data.dart';
// // import 'package:fly_chatting_app/models/user_model.dart';
// // import 'package:fly_chatting_app/providers/contact_service_provider.dart';
// // import 'package:fly_chatting_app/providers/search_provider.dart';
// // import 'package:fly_chatting_app/screens/ChatScreen.dart';
// // import 'package:fly_chatting_app/widgets/cupertino_text_button.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:provider/provider.dart';
// // import 'package:url_launcher/url_launcher.dart';
// //
// // class ContactScreen extends StatefulWidget {
// //   const ContactScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   State<ContactScreen> createState() => _ContactScreenState();
// // }
// //
// // class _ContactScreenState extends State<ContactScreen> {
// //   _launchURL(String num) async {
// //     log('-------- $num hii ---------');
// //
// //     final String url = 'sms: $num ?body=hello%20there';
// //     var uri = Uri.parse(url);
// //     if (await canLaunchUrl(uri)) {
// //       await launchUrl(uri);
// //     } else {
// //       throw 'Could not launch $url';
// //     }
// //   }
// //
// //   // @override
// //   // void initState() {
// //   //   getContactPermission();
// //   //   super.initState();
// //   // }
// //   //
// //   // Future<void> getContactPermission() async {
// //   //   if (await Permission.contacts.isGranted) {
// //   //     await context.read<ContactProvider>().getPhoneContacts();
// //   //   } else {
// //   //     await Permission.contacts.request();
// //   //   }
// //   // }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     log('Build ContactScreen');
// //     return Scaffold(
// //       appBar: AppBar(
// //         elevation: 0.0,
// //         leading: IconButton(
// //             onPressed: () {
// //               Navigator.of(context).pop();
// //             },
// //             icon: const Icon(Icons.arrow_back)),
// //         title: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const Text(
// //               'Select Contact',
// //               style: TextStyle(fontFamily: "Rounded Bold", fontSize: 18),
// //             ),
// //             Text(
// //               '${context.read<ContactProvider>().firebaseContact.length + context.read<ContactProvider>().temps.length} contacts',
// //               style: const TextStyle(fontSize: 13, fontFamily: "Rounded Bold"),
// //             )
// //           ],
// //         ),
// //       ),
// //       body: ListView(children: [
// //         FutureBuilder<List<UserModel>>(
// //           future: context.read<ContactProvider>().getFirebaseContacts(),
// //           builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
// //             log('----------------------------------- firebase contacts...CONTACT SCREEN ----------------------------------');
// //             return Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Padding(
// //                   padding: const EdgeInsets.only(top: 16, right: 18, left: 18),
// //                   child: TextFormField(
// //                     controller: context.read<SearchProvider>().searchController,
// //                     onChanged: (value) {},
// //                     decoration: InputDecoration(
// //                         contentPadding: const EdgeInsets.symmetric(
// //                             horizontal: 25, vertical: 14),
// //                         hintText: 'Search',
// //                         hintStyle: const TextStyle(
// //                           color: Colors.grey,
// //                           fontSize: 15,
// //                         ),
// //                         enabledBorder: const OutlineInputBorder(
// //                           borderSide: BorderSide(width: 1, color: Colors.grey),
// //                           borderRadius: BorderRadius.all(Radius.circular(23)),
// //                         ),
// //                         focusedBorder: const OutlineInputBorder(
// //                           borderSide:
// //                               BorderSide(width: 1.6, color: Colors.blue),
// //                           borderRadius: BorderRadius.all(Radius.circular(23)),
// //                         ),
// //                         prefixIcon: CupertinoButton(
// //                           child: Image.asset(
// //                             'assets/icons/search.png',
// //                             color: Colors.blue,
// //                             width: 18,
// //                           ),
// //                           onPressed: () {},
// //                         ),
// //                         suffixIcon: CupertinoButton(
// //                           padding: EdgeInsets.zero,
// //                           child: const Icon(
// //                             Icons.close,
// //                           ),
// //                           onPressed: () {
// //                             //TODO clear
// //                           },
// //                         ),
// //                         filled: true,
// //                         fillColor: Colors.grey.withOpacity(.06)),
// //                   ),
// //                 ),
// //                 const Padding(
// //                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //                   child: Text(
// //                     'Contacts on FlyChat',
// //                     style: TextStyle(
// //                         fontFamily: 'Rounded Bold',
// //                         fontSize: 16,
// //                         color: Colors.black54),
// //                   ),
// //                 ),
// //                 ListView.builder(
// //                   shrinkWrap: true,
// //                   physics: const NeverScrollableScrollPhysics(),
// //                   itemCount: snapshot.data?.length ?? 0,
// //                   itemBuilder: (context, index) {
// //                     return ListTile(
// //                       contentPadding:
// //                           const EdgeInsets.only(left: 18, right: 10),
// //                       onTap: () async {
// //                         final targetData = await FirebaseFirestore.instance
// //                             .collection('users')
// //                             .where('phoneNumber',
// //                                 isEqualTo: snapshot.data![index].phoneNumber)
// //                             .get();
// //
// //                         UserModel targetUser =
// //                             UserModel.fromMap(targetData.docs.first.data());
// //                         ChatCheckModel? chatCheck =
// //                             await FirebaseData.getParticipantChat(targetUser);
// //
// //                         if (chatCheck != null) {
// //                           Navigator.of(context).pop();
// //                           Navigator.of(context).push(
// //                             MaterialPageRoute(
// //                               builder: (context) => ChatScreen(
// //                                 targetUser: targetUser,
// //                                 chatCheck: chatCheck,
// //                               ),
// //                             ),
// //                           );
// //                         }
// //                       },
// //                       title: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(snapshot.data![index].fullName.toString(),
// //                               style: const TextStyle(
// //                                   fontFamily: 'Rounded ExtraBold')),
// //                           Text(
// //                             snapshot.data![index].about.toString(),
// //                             style: const TextStyle(
// //                                 fontSize: 14,
// //                                 color: Colors.black54,
// //                                 fontFamily: 'Rounded ExtraBold'),
// //                           )
// //                         ],
// //                       ),
// //                       leading: CircleAvatar(
// //                         radius: 22,
// //                         backgroundColor: Colors.grey.withOpacity(.40),
// //                         backgroundImage: snapshot.data![index].profilePicture !=
// //                                 null
// //                             ? NetworkImage(
// //                                 snapshot.data![index].profilePicture.toString())
// //                             : null,
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ],
// //             );
// //           },
// //         ),
// //         FutureBuilder<List<UserModel?>>(
// //           future: context.read<ContactProvider>().getInvite(),
// //           builder: (context, AsyncSnapshot<List<UserModel?>> snapshot) {
// //             log('----------------------------------- phone contacts...CONTACT SCREEN -----------------------------------');
// //             if (snapshot.connectionState == ConnectionState.waiting) {
// //               return const Center(
// //                 child: CircularProgressIndicator(),
// //               );
// //             } else {
// //               if (snapshot.hasData) {
// //                 return Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const Padding(
// //                       padding:
// //                           EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //                       child: Text(
// //                         'Invite to FlyChat',
// //                         style: TextStyle(
// //                             fontFamily: 'Rounded Bold',
// //                             fontSize: 16,
// //                             color: Colors.black54),
// //                       ),
// //                     ),
// //                     ListView.builder(
// //                       shrinkWrap: true,
// //                       physics: const NeverScrollableScrollPhysics(),
// //                       itemCount: snapshot.data?.length ?? 0,
// //                       itemBuilder: (context, index) {
// //                         return ListTile(
// //                           contentPadding:
// //                               const EdgeInsets.only(left: 18, right: 10),
// //                           onTap: () {
// //                             String num = snapshot.data![index]!.phoneNumber;
// //                             _launchURL(num);
// //                           },
// //                           title: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Text(snapshot.data![index]!.fullName.toString(),
// //                                   style: const TextStyle(
// //                                     fontFamily: 'Rounded ExtraBold',
// //                                     fontSize: 15,
// //                                   )),
// //                               Text(
// //                                 snapshot.data![index]!.phoneNumber,
// //                                 style: const TextStyle(
// //                                     fontSize: 13.5,
// //                                     color: Colors.black54,
// //                                     fontFamily: 'Rounded Bold'),
// //                               ),
// //                               const SizedBox(height: 5)
// //                             ],
// //                           ),
// //                           leading: CircleAvatar(
// //                             radius: 22,
// //                             backgroundColor: Colors.grey.withOpacity(.30),
// //                             child: Image.asset(
// //                               'assets/icons/person_2.png',
// //                               height: 32,
// //                               color: Colors.white70,
// //                             ),
// //                           ),
// //                           trailing: BuildCupertinoButtonText(
// //                             onPressed: () {
// //                               String num = snapshot.data![index]!.phoneNumber;
// //                                _launchURL(num);
// //                             },
// //                             title: 'Invite',
// //                             style: TextStyle(
// //                                 fontWeight: FontWeight.bold,
// //                                 fontSize: 14,
// //                                 letterSpacing: 0.8,
// //                                 color: Theme.of(context)
// //                                     .appBarTheme
// //                                     .backgroundColor,
// //                                 fontFamily: "Varela Round Regular"),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                   ],
// //                 );
// //               } else {
// //                 return const Text('no have data...');
// //               }
// //             }
// //             return const SizedBox();
// //           },
// //         ),
// //       ]),
// //     );
// //   }
// // }
//
// // ignore_for_file: use_build_context_synchronously
//
// import 'dart:developer';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fly_chatting_app/models/chats_check_participant_model.dart';
// import 'package:fly_chatting_app/models/firebase_data.dart';
// import 'package:fly_chatting_app/models/user_model.dart';
// import 'package:fly_chatting_app/providers/contact_service_provider.dart';
// import 'package:fly_chatting_app/providers/search_provider.dart';
// import 'package:fly_chatting_app/screens/ChatScreen.dart';
// import 'package:fly_chatting_app/widgets/cupertino_text_button.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class ContactScreen extends StatefulWidget {
//   const ContactScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ContactScreen> createState() => _ContactScreenState();
// }
//
// class _ContactScreenState extends State<ContactScreen> {
//   TextEditingController searchController = TextEditingController();
//   List<UserModel?> temps = [];
//   bool isLoading = true;
//
//
//   @override
//   void initState() {
//     super.initState();
//     getContactPermission();
//   }
//
//   void getContactPermission() async {
//     if (await Permission.contacts.isGranted) {
//       await fetchContacts();
//     } else {
//       await Permission.contacts.request();
//     }
//   }
//
//   Future<void> fetchContacts() async {
//     List<Contact> contact =
//         await ContactsService.getContacts(withThumbnails: false);
//     final temp = contact.map((e) => convertContactModel(e)).toList();
//     temp.removeWhere((element) => element == null);
//     temps = temp;
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   UserModel? convertContactModel(Contact contact) {
//     try {
//       return UserModel(
//         uid: '',
//         phoneNumber: contact.phones!.first.value ?? 'Invalid Phone',
//         fullName: contact.displayName ?? 'User',
//       );
//     } catch (e) {
//       return null;
//     }
//   }
//
//   _launchURL(String num) async {
//     log('-------- $num hii ---------');
//
//     final String url = 'sms: $num ?body=hello%20there';
//     var uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     log('Build ContactScreen');
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.0,
//         leading: IconButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             icon: const Icon(Icons.arrow_back)),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.search),
//           ),
//         ],
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Select Contact',
//               style: TextStyle(fontFamily: "Rounded Bold", fontSize: 18),
//             ),
//             Text(
//               '5 contacts',
//               style: const TextStyle(fontSize: 13, fontFamily: "Rounded Bold"),
//             )
//           ],
//         ),
//       ),
//       body: isLoading? const Center(child: CircularProgressIndicator(),):ListView.builder(
//         itemCount: temps.length,
//         itemBuilder: (context, index) {
//           log('----------------------------------- phone contacts...CONTACT SCREEN -----------------------------------');
//           return ListTile(
//             contentPadding: const EdgeInsets.only(left: 18, right: 10),
//             onTap: ()  {
//             },
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(temps[index]!.fullName.toString(),
//                     style: const TextStyle(fontFamily: 'Rounded ExtraBold')),
//                 Text(
//                   temps[index]!.phoneNumber.toString(),
//                   style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.black54,
//                       fontFamily: 'Rounded ExtraBold'),
//                 )
//               ],
//             ),
//
//           );
//         },
//       ),
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/models/chats_check_participant_model.dart';
import 'package:fly_chatting_app/models/firebase_data.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/providers/contact_service_provider.dart';
import 'package:fly_chatting_app/screens/ChatScreen.dart';
import 'package:fly_chatting_app/widgets/cupertino_text_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatContactScreen extends StatefulWidget {
  const ChatContactScreen({Key? key}) : super(key: key);

  @override
  State<ChatContactScreen> createState() => _ChatContactScreenState();
}

class _ChatContactScreenState extends State<ChatContactScreen> {
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
                        onTap: () async {
                          final targetData = await FirebaseFirestore.instance
                              .collection('users')
                              .where('phoneNumber',
                                  isEqualTo: contact.phoneNumber)
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
