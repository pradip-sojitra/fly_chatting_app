import 'package:flutter/material.dart';
import 'package:fly_chatting_app/screens/calls_contact_screen.dart';

class CallsHomeScreen extends StatelessWidget {
  const CallsHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: const Center(child: Text('calls')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CallContactScreen(),
            ),
          );
        },
        child: const Icon(Icons.add_ic_call_rounded),
      ),
    );
  }
}
