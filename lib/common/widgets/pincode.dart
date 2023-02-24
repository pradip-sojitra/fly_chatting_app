import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fly_chatting_app/common/widgets/theme/colors_style.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCode extends StatelessWidget {
  const PinCode({Key? key,required this.controller}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      keyboardType: TextInputType.number,
      controller: controller,
      length: 6,
      enableActiveFill: true,
      cursorColor: Colors.black,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        fieldWidth: 52,
        fieldHeight: 52,
        selectedColor: AppColors.darkBlueColor,
        activeColor: AppColors.darkBlueColor,
        inactiveColor: AppColors.lightBlueColor,
        disabledColor: AppColors.lightBlueColor,
        selectedFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        activeFillColor: Colors.transparent,
        borderWidth: 2,
        borderRadius: BorderRadius.circular(14),
      ),
      appContext: context,
      onChanged: (String value) {
        log(value);
      },
    );
  }
}
