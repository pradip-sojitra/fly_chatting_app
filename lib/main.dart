import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fly_chatting_app/home/home_screen.dart';
import 'package:fly_chatting_app/home/tab_bar/calls_pages/provider/calls_provider.dart';
import 'package:fly_chatting_app/common/local_db/local_db.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/group_chats/provider/group_chat_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/provider/chat_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/provider/contact_service_provider.dart';
import 'package:fly_chatting_app/common/provider/theme_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/screens/message_screen.dart';
import 'package:fly_chatting_app/home/tab_bar/status_pages/provider/status_provider.dart';
import 'package:fly_chatting_app/splash_welocome/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp();
  await sharedPref.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ContactProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CallProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => StatusProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GroupChatProvider(),
        )
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, val, child) {
          return MaterialApp(
            theme: val.isChangeTheme
                ? ThemeData.dark().copyWith(
                    appBarTheme: const AppBarTheme(
                      systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        systemNavigationBarColor: Colors.transparent,
                      ),
                    ),
                    floatingActionButtonTheme:
                        const FloatingActionButtonThemeData(
                      backgroundColor: Colors.blue,
                    ),
                    textTheme: const TextTheme(
                      titleMedium: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ThemeData.light().copyWith(
              scaffoldBackgroundColor: Colors.grey.shade200,
                    appBarTheme: const AppBarTheme(
                      systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        systemNavigationBarColor: Colors.transparent,
                      ),
                    ),
                  ),
            debugShowCheckedModeBanner: false,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return const HomeScreen();
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}

/*
ThemeData(
scaffoldBackgroundColor: AppColors.lightFullBlueColor,
fontFamily: 'Varela Round Regular',
appBarTheme: const AppBarTheme(
backgroundColor: AppColors.lightBlueColor,
elevation: 0.0,
))*/
