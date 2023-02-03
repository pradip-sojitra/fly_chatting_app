// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/models/local_db.dart';
import 'package:fly_chatting_app/providers/contact_service_provider.dart';
import 'package:fly_chatting_app/providers/theme_provider.dart';
import 'package:fly_chatting_app/screens/Status_home_page.dart';
import 'package:fly_chatting_app/screens/calls_home_screen.dart';
import 'package:fly_chatting_app/screens/chat_home_page.dart';
import 'package:fly_chatting_app/screens/chat_contacts_screen.dart';
import 'package:fly_chatting_app/screens/login_Screen.dart';
import 'package:provider/provider.dart';

enum SampleItem { itemOne, itemSecond }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SampleItem? selectedMenu;

  @override
  void initState() {
    super.initState();
    context.read<ThemeProvider>().getLocal();
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
                        ? const Image(
                            image: AssetImage('assets/icons/moon.png'),
                            color: Colors.white,
                            height: 25,
                          )
                        : const Icon(
                            Icons.sunny,
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
              initialValue: selectedMenu,
              onSelected: (SampleItem item) {
                setState(() {
                  selectedMenu = item;
                });
              },
              iconSize: 28,
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  onTap: () {},
                  value: SampleItem.itemOne,
                  child: const Text('Profile'),
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
                  value: SampleItem.itemSecond,
                  child: const Text('Log Out'),
                ),
              ],
            ),
          ],
          bottom: const TabBar(
            indicatorWeight: 3,
            labelPadding: EdgeInsets.symmetric(vertical: 12),
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: [
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
        body: const TabBarView(
          children: [
            ChatHomePage(),
            StatusHomePage(),
            CallsHomeScreen(),
          ],
        ),
      ),
    );
  }
}
