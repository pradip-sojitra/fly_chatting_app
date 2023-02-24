import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuildCupertinoButtonIcon extends StatelessWidget {

  const BuildCupertinoButtonIcon(
      {super.key, required this.onPressed,this.color, this.title, this.icons,});
 final String? title;
 final IconData? icons;
 final Color? color;
 final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),),
            child: Icon(
              icons,
              size: 26,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title!,
            style: const TextStyle(letterSpacing: 0.4,
              color: Colors.black, fontWeight: FontWeight.w400,),
          )
        ],
      ),
    );
  }
}
