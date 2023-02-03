import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:flutter/material.dart';

const appId = '4541de78320b434da6ec8882d4629e10';
const channelName = 'first';
const token =
    '007eJxTYAjR+Cikv58/3KEucvEsg6LZEp/WL2RNCra41ekSfvDpJRsFBhNTE8OUVHMLYyODJBNjk5REs9RkCwsLoxQTMyPLVEMDy8l3khsCGRlWHONhZmSAQBCflSEts6i4hIEBANnrHjQ=';

class VideoCall extends StatefulWidget {
  const VideoCall({Key? key}) : super(key: key);

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {

  SessionController _sessionController = SessionController();
  SessionController get sessionController => _sessionController;

  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
        appId: appId, channelName: channelName),
    enabledPermission: [
      Permission.camera,
      Permission.microphone,
    ],
  );


  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          AgoraVideoViewer(client: client),
          AgoraVideoButtons(client: client),
        ]),
      ),
    );
  }
}
