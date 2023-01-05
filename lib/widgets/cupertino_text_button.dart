import 'package:flutter/cupertino.dart';
import 'package:fly_chatting_app/widgets/theme/colors_style.dart';

class BuildCupertinoButtonText extends StatelessWidget {
 const BuildCupertinoButtonText(
      {Key? key, required this.onPressed, required this.title, this.style})
      : super(key: key);

 final void Function()? onPressed;
 final String title;
 final TextStyle? style;



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
