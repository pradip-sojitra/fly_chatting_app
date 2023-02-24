import 'package:flutter/material.dart';

class Messenger {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> messengerScaffold(
          {required String text, required BuildContext context}) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          backgroundColor: Colors.red.shade400,
          content: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
}
