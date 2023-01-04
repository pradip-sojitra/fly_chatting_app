import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/models/user_model.dart';
import 'package:fly_chatting_app/screens/contacts._screen.dart';
import 'package:fly_chatting_app/screens/login_Screen.dart';
import 'package:fly_chatting_app/widgets/theme/colors_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.userModel,
    required this.firebaseUser,
  });

  final User firebaseUser;
  final UserModel userModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: const [
            Image(
              image: AssetImage('assets/images/main_icon_3_5.png'),
              height: 60,
              width: 60,
            ),
            SizedBox(width: 10),
            Text(
              'FlyChat',
              style: TextStyle(letterSpacing: 0.6, fontFamily: 'Rounded Black'),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Image(
              image: AssetImage('assets/icons/search.png'),
              height: 25,
            ),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              });
            },
            icon: const Image(
              image: AssetImage('assets/icons/menu-vertical.png'),
              height: 28,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {},
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueGrey.shade50,
                    radius: 28,
                    child: const Image(
                      image: AssetImage('assets/icons/person_2.png'),
                      height: 38,
                      color: Color(0xffadb5bd),
                    ),
                  ),
                  title: const Text(
                    'Pradip Sojitra',
                    style: TextStyle(fontFamily: 'Rounded ExtraBold'),
                  ),
                  subtitle: const Text(
                    "Hii...I'm there..",
                    style: TextStyle(
                      fontFamily: 'Varela Round Regular',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 6,
                  color: Color(0x0F7ca6fe),
                  thickness: 6,
                  indent: 32,
                  endIndent: 0,
                );
              },
              itemCount: 10,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: lightBlueColor,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<dynamic>(
              builder: (context) {
                return ContactScreen(
                  firebaseUser: widget.firebaseUser,
                  userModel: widget.userModel,
                );
              },
            ),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
