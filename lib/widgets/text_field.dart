import 'package:flutter/material.dart';
import 'package:fly_chatting_app/widgets/theme/colors_style.dart';

class BuildTextField extends StatelessWidget {
  String? hintText;
  TextInputAction? textInputAction;
  TextEditingController? controller;
  BuildTextField({Key? key,this.controller,this.hintText,this.textInputAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black,fontSize: 14,fontFamily: "Varela Round Regular"),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14)
          ),
          filled: true,
          fillColor: lightDimBlueColor
      ),
    );
  }
}
