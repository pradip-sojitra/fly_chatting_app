import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/models/firebase_data.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/providers/contacts_provider.dart';
import 'package:fly_chatting_app/screens/home_screen.dart';
import 'package:fly_chatting_app/screens/splash_screen.dart';
import 'package:fly_chatting_app/widgets/theme/colors_style.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    UserModel? userModel = await FirebaseData.getUserData(uid: user.uid);

    if (userModel != null) {
      runApp(MyAppLoggedIn(userModel: userModel, firebaseUser: user));
    } else {
      runApp(const MyApp());
    }
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: AppColors.lightFullBlueColor,
          fontFamily: "Varela Round Regular",
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.lightBlueColor,
            elevation: 0.0,
          )),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ContactSearchProvider(),),
      ],
      child: MaterialApp(
        theme: ThemeData(
            scaffoldBackgroundColor: AppColors.lightFullBlueColor,
            fontFamily: 'Varela Round Regular',
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.lightBlueColor,
              elevation: 0.0,
            )),
        debugShowCheckedModeBanner: false,
        home: HomeScreen(userModel: userModel, firebaseUser: firebaseUser),
      ),
    );
  }
}
