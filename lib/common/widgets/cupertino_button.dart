import 'package:flutter/cupertino.dart';
import 'package:fly_chatting_app/common/widgets/theme/colors_style.dart';

class BuildCupertinoButton extends StatelessWidget {

  const BuildCupertinoButton(
      {super.key, required this.onPressed, required this.title, this.style,});
final  void Function()? onPressed;
 final String title;
 final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: CupertinoButton(
        onPressed: onPressed,
        color: AppColors.darkBlueColor,
        borderRadius: BorderRadius.circular(50),
        child: Text(title,
          style: (style == null)
              ? const TextStyle(
            fontSize: 18, fontFamily: 'Varela Round Regular',)
              : style,),
      ),
    );
  }
}
