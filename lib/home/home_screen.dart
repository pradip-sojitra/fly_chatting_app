// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/auth/screens/login_Screen.dart';
import 'package:fly_chatting_app/common/utils.dart';
import 'package:fly_chatting_app/home/tab_bar/calls_pages/screens/call_list_screen.dart';
import 'package:fly_chatting_app/home/tab_bar/calls_pages/screens/contact_call_screen.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/group_chats/screens/create_group_screen.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/screens/chat_list_screen.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/screens/contact_chat_screen.dart';
import 'package:fly_chatting_app/home/tab_bar/status_pages/screens/status_contacts_screen.dart';
import 'package:fly_chatting_app/common/local_db/local_db.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/provider/chat_provider.dart';
import 'package:fly_chatting_app/common/provider/theme_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/status_pages/screens/confirm_status_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    context.read<ThemeProvider>().getLocal();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _tabController?.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        context
            .read<ChatProvider>()
            .isOnlineChanged(true, DateTime.now().millisecondsSinceEpoch);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        context
            .read<ChatProvider>()
            .isOnlineChanged(false, DateTime.now().millisecondsSinceEpoch);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    log('build_HomeScreen');
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: const [
              Image(
                image: AssetImage('assets/images/main_icon_3_5.png'),
                height: 44,
                width: 44,
              ),
              SizedBox(width: 10),
              Text(
                'FlyChat',
                style:
                    TextStyle(letterSpacing: 0.6, fontFamily: 'Rounded Black'),
              ),
            ],
          ),
          actions: [
            Consumer<ThemeProvider>(
              builder: (context, provider, child) {
                return IconButton(
                  onPressed: () {
                    provider.changeTheme();
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 450),
                    child: provider.isChangeTheme
                        ? const Icon(
                      Icons.dark_mode_rounded,
                      size: 24,
                    )
                        : const Icon(
                            Icons.light_mode_rounded,
                            size: 24,
                          ),
                  ),
                );
              },
            ),
            IconButton(
              onPressed: () {},
              icon: const Image(
                image: AssetImage('assets/icons/search.png'),
                height: 20,
              ),
            ),
            PopupMenuButton(
              iconSize: 28,
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  onTap: () {},
                  child: const Text('Profile'),
                ),
                PopupMenuItem(
                  onTap: () => Future(
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateGroupScreen(),
                      ),
                    ),
                  ),
                  child: const Text('Create Group'),
                ),
                PopupMenuItem(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut().then((value) {
                      sharedPref.logOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    });
                  },
                  child: const Text('Log Out'),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorWeight: 3,
            labelPadding: const EdgeInsets.symmetric(vertical: 12),
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: const [
              Text(
                'Chats',
                style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 0.2,
                    fontFamily: 'Rounded Bold'),
              ),
              Text(
                'Status',
                style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 0.2,
                    fontFamily: 'Rounded Bold'),
              ),
              Text(
                'Calls',
                style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 0.2,
                    fontFamily: 'Rounded Bold'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            ChatListScreen(),
            StatusContactsScreen(),
            CallsHomeScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          onPressed: () async {
            if (_tabController?.index == 0) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ContactChatScreen(),
                ),
              );
            } else if (_tabController?.index == 1) {
              File? pickedImage =
                  await selectedImage(context, ImageSource.gallery);
              if (pickedImage != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ConfirmStatusScreen(file: pickedImage),
                  ),
                );
              }
            } else if (_tabController?.index == 2) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ContactCallScreen(),
                ),
              );
            }
          },
          child: _tabController?.index == 0
              ? const Icon(Icons.chat)
              : _tabController?.index == 1
                  ? const Icon(Icons.camera)
                  : const Icon(Icons.add_ic_call_rounded),
        ),
      ),
    );
  }
}
