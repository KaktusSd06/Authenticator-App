import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/config/theme.dart' as Colors;


import '../../core/config/theme.dart';

class BtnWithStoke extends StatelessWidget {
  final VoidCallback?  onPressed;
  final String text;

  const BtnWithStoke({
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(color: mainBlue, width: 2)
          ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
          color: mainBlue,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}