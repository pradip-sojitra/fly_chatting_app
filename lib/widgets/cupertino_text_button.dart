import 'package:flutter/cupertino.dart';
import 'package:fly_chatting_app/widgets/theme/colors_style.dart';

class BuildCupertinoButtonText extends StatelessWidget {
  void Function()? onPressed;
  String title;
  TextStyle? style;

  BuildCupertinoButtonText(
      {Key? key, required this.onPressed, required this.title, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Text(title,
          style: (style != null)
              ? style
              : const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 0.1,
              color: darkBlueColor,fontFamily: "Varela Round Regular")),
    );
  }
}
