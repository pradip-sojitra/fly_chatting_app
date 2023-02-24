import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/home/tab_bar/calls_pages/provider/calls_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/calls_pages/screens/pickup/pickup_screen.dart';
import 'package:fly_chatting_app/models/call_model.dart';
import 'package:provider/provider.dart';

class PickupLayoutScreen extends StatelessWidget {
  const PickupLayoutScreen({Key? key, required this.scaffold})
      : super(key: key);
  final Widget scaffold;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: context.watch<CallProvider>().callStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          CallModel call =
              CallModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);

          if (!call.hasDialled!) {
            return PickupScreen(call: call);
          }
          return scaffold;
        }
        return scaffold;
      },
    );
  }
}
