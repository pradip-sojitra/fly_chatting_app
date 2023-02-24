import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fly_chatting_app/common/provider/commom_provider.dart';
import 'package:fly_chatting_app/home/home_screen.dart';
import 'package:fly_chatting_app/home/tab_bar/calls_pages/provider/calls_provider.dart';
import 'package:fly_chatting_app/common/local_db/local_db.dart';
import 'package:fly_chatting_app/home/tab_bar/calls_pages/screens/pickup/pickup_layout.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/provider/chat_&_message_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/provider/contact_service_provider.dart';
import 'package:fly_chatting_app/common/provider/theme_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/status_pages/provider/status_provider.dart';
import 'package:fly_chatting_app/splash_welocome/screens/splash_screen.dart';
import 'package:provider/provider.dart';

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
          create: (context) => CommonFirebaseStorageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => StatusProvider(),
        )
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, val, child) {
          return MaterialApp(
            theme: val.isChangeTheme
                ? ThemeData.dark().copyWith(
                    floatingActionButtonTheme:
                        const FloatingActionButtonThemeData(
                            backgroundColor: Colors.blue),
                  )
                : ThemeData.light(),
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
