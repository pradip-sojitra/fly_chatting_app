import 'package:flutter/material.dart';
import 'package:fly_chatting_app/common/widgets/theme/colors_style.dart';

class BuildTextField extends StatelessWidget {
  const BuildTextField(
      {Key? key, this.controller, this.hintText, this.textInputAction})
      : super(key: key);

  final String? hintText;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          hintText: hintText,
          hintStyle: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: "Varela Round Regular"),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14)),
          filled: true,
          fillColor: AppColors.lightDimBlueColor),
    );
  }
}
