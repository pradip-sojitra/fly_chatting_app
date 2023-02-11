import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/home/home_screen.dart';
import 'package:fly_chatting_app/providers/agora_provider.dart';
import 'package:fly_chatting_app/models/local_db.dart';
import 'package:fly_chatting_app/providers/chat_provider.dart';
import 'package:fly_chatting_app/providers/contact_service_provider.dart';
import 'package:fly_chatting_app/providers/theme_provider.dart';
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
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, val, child) {
          return MaterialApp(
            theme: val.isChangeTheme
                ? ThemeData.dark().copyWith(
                    floatingActionButtonTheme:
                        const FloatingActionButtonThemeData(
                            backgroundColor: Colors.blue))
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
