// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fly_chatting_app/home/tab_bar/status_pages/provider/status_provider.dart';
import 'package:provider/provider.dart';

class ConfirmStatusScreen extends StatelessWidget {
  const ConfirmStatusScreen({Key? key, required this.file}) : super(key: key);

  final File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              size: 28,
            )),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Image.file(file, fit: BoxFit.cover),
      ),
      floatingActionButton: Consumer<StatusProvider>(
        builder: (context, value, child) {
          return FloatingActionButton(
            onPressed: () async {
             await value.uploadStatus(file: file, context: context);
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Icon(
                Icons.send_rounded,
                size: 27,
              ),
            ),
          );
        },
      ),
    );
  }
}
