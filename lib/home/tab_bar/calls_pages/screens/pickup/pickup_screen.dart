import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/home/tab_bar/calls_pages/screens/video_call.dart';
import 'package:fly_chatting_app/home/tab_bar/calls_pages/provider/calls_provider.dart';
import 'package:fly_chatting_app/models/call_model.dart';
import 'package:provider/provider.dart';

class PickupScreen extends StatelessWidget {
  const PickupScreen({Key? key, required this.call}) : super(key: key);

  final CallModel call;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Incoming...',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 50),
            CachedNetworkImage(
              imageUrl: call.callerPic,
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 15),
            Text(
              call.callerName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    await context.read<CallProvider>().endCall(call: call);
                  },
                  icon: const Icon(
                    Icons.call_end,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(width: 25),
                IconButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VideoCallScreen(call: call),
                    ));
                  },
                  icon: const Icon(
                    Icons.call,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
