import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/screens/welcome_screen.dart';
import 'package:fly_chatting_app/widgets/theme/colors_style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
          (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Hero(
              tag: "chatImageMain",
              child: Image(
                image: AssetImage("assets/images/main_icon_4.png"),
              ),
            ),
            const SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "FlyChat!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlueColor,
                      fontSize: 34,
                      letterSpacing: 3,
                      fontFamily: "Rounded Black"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
