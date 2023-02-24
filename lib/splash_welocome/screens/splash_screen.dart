import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/common/widgets/theme/colors_style.dart';
import 'package:fly_chatting_app/splash_welocome/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    splash();
    super.initState();
  }

  void splash() {
    Timer(const Duration(seconds: 3), () async {
      await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
          (route) => false);
    });
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
