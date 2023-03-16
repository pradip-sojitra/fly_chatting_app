import 'package:flutter/material.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/group_chats/provider/group_chat_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/provider/contact_service_provider.dart';
import 'package:provider/provider.dart';

class SelectContactGroupScreen extends StatefulWidget {
  const SelectContactGroupScreen({Key? key}) : super(key: key);

  @override
  State<SelectContactGroupScreen> createState() =>
      _SelectContactGroupScreenState();
}

class _SelectContactGroupScreenState extends State<SelectContactGroupScreen> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<ContactProvider>().getFirebaseContacts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final contact = snapshot.data![index];
            return InkWell(
              onTap: () => context
                  .read<GroupChatProvider>()
                  .selectContact(userData: snapshot.data![index]),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact!.fullName,
                      style: const TextStyle(
                        fontFamily: 'Rounded Bold',
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      contact.about!,
                      style: const TextStyle(
                        fontFamily: 'Rounded Bold',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                leading: context
                        .watch<GroupChatProvider>()
                        .selectedContacts
                        .contains(snapshot.data![index])
                    ? Stack(
                        children: [
                          CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.blueGrey.shade50,
                              backgroundImage: contact.profilePicture!.isEmpty
                                  ? null
                                  : NetworkImage(contact.profilePicture!),
                              child: contact.profilePicture!.isEmpty
                                  ? const Image(
                                      image: AssetImage(
                                          'assets/icons/person_2.png'),
                                      height: 38,
                                      color: Color(0xffadb5bd),
                                    )
                                  : null),
                          const Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 8.5,
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.done,
                                    color: Colors.white, size: 14),
                              ),
                            ),
                          )
                        ],
                      )
                    : CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.blueGrey.shade50,
                        backgroundImage: contact.profilePicture!.isEmpty
                            ? null
                            : NetworkImage(contact.profilePicture!),
                        child: contact.profilePicture!.isEmpty
                            ? const Image(
                                image: AssetImage('assets/icons/person_2.png'),
                                height: 38,
                                color: Color(0xffadb5bd),
                              )
                            : null),
              ),
            );
          },
        );
      },
    );
  }
}
