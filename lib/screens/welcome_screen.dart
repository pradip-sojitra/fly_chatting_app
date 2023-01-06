import 'package:flutter/material.dart';
import 'package:fly_chatting_app/screens/login_Screen.dart';
import 'package:fly_chatting_app/widgets/cupertino_button.dart';
import 'package:fly_chatting_app/widgets/theme/colors_style.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Hero(
              tag: "chatImageMain",
              child: Image(
                image: AssetImage("assets/images/main_icon_4.png"),
              ),
            ),
            Expanded(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Welcome to ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBlueColor,
                                fontSize: 30,
                                fontFamily: "Rounded Black")),
                        Text("FlyChat!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBlueColor,
                                fontSize: 32,
                                fontFamily: "Rounded Black")),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "The best messenger and chat app of the century to make your day great",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: BuildCupertinoButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                  (route) => false);
                            },
                            title: "Get Started"),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
