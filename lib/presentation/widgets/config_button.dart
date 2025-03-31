import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfigButton extends StatelessWidget {
  final String text;
  final VoidCallback?  onPressed;
  final Color btnColor;
  final TextStyle? textStyle;
  final double borderRadius;
  final double verticalPadding;

  const ConfigButton({
    required this.text,
    required this.onPressed,
    required this.btnColor,
    required this.textStyle,
    this.borderRadius = 8.0,
    required this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)
          )
        ),
        child: Text(
          text,
          style: textStyle,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
    );
  }


}