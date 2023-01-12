import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/models/firebase_data.dart';
import 'package:fly_chatting_app/models/local_db.dart';
import 'package:fly_chatting_app/providers/contacts_provider.dart';
import 'package:fly_chatting_app/providers/theme_provider.dart';
import 'package:fly_chatting_app/providers/userDataProvider.dart';
import 'package:fly_chatting_app/screens/home_screen.dart';
import 'package:fly_chatting_app/screens/splash_screen.dart';
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
          create: (context) => ContactSearchProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserDataProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, val, child) {
          return MaterialApp(
            theme: val.isCheckTheme ? ThemeData.dark() : ThemeData.light(),
            debugShowCheckedModeBanner: false,
            home: MainScreen(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;

  // Future<void> usersData =
  //     FirebaseData.getUserData(uid: FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return FutureBuilder(
            future: FirebaseData.getUserData(uid: user!.uid),
            builder: (context, allData) {
              if (snapshot.hasData) {
                return HomeScreen(
                    userModel: allData.data!, firebaseUser: user!);
              }
              return Container();
            },
          );
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

//
// User? user = FirebaseAuth.instance.currentUser;
//
// if (user != null) {
// UserModel? userModel = await FirebaseData.getUserData(uid: user.uid);
//
// if (userModel != null) {
// runApp(MyAppLoggedIn(userModel: userModel, firebaseUser: user));
// } else {
// runApp(const MyApp());
// }
// } else {
// runApp(const MyApp());
// }

//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//           scaffoldBackgroundColor: AppColors.lightFullBlueColor,
//           fontFamily: "Varela Round Regular",
//           appBarTheme: const AppBarTheme(
//             backgroundColor: AppColors.lightBlueColor,
//             elevation: 0.0,
//           )),
//       debugShowCheckedModeBanner: false,
//       home: const SplashScreen(),
//     );
//   }
// }
