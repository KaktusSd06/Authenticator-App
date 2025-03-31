import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/config/theme.dart' as Colors;

class OnBoardingScreen1 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/onboarding_bg_1.png"),
          fit: BoxFit.cover,
        )
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 165, right: 16, left: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(textAlign: TextAlign.center, AppLocalizations.of(context)!.onBoarding_H1, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white),),
            SizedBox(height: 24,),
            Text(textAlign: TextAlign.center, AppLocalizations.of(context)!.onBoarding_T1, style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w400, color: Colors.gray2))
          ],
        )
      ),
    );
  }
}