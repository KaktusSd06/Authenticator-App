import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../core/config/theme.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback?  onPressed;

  const ContinueButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: onPressed == null ? gray4 : lightBlue,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)
          ),
          //elevation: onPressed == null ? 1 : 0,
      ),
      child: Text(
        AppLocalizations.of(context)!.continue_btn,
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