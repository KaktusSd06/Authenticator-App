
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/config/theme.dart' as Colors;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen4 extends StatelessWidget{
  final PageController controller;

  const OnBoardingScreen4({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/onboarding_bg_4.png"),
            fit: BoxFit.cover,
          )
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 60, left: 23, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {

                    },
                    child: SvgPicture.asset(
                      "assets/icons/x.svg",
                      width: 10,
                      height: 10,
                      colorFilter: ColorFilter.mode(Colors.mainBlue, BlendMode.srcIn),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.animateToPage(
                        0,
                        duration: Duration(milliseconds: 800),
                        curve: Curves.easeInOut,
                      );                    },
                    child:
                    Text(
                      AppLocalizations.of(context)!.restor_l,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500, color: Colors.mainBlue),
                    ),
                  ),
                ],
              ),
            ),
          ),


          /// Заповнювач, щоб відсунути текст до низу
          Spacer(),

          /// Нижній текстовий блок
          Padding(
            padding: const EdgeInsets.only(bottom: 28, right: 16, left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  AppLocalizations.of(context)!.onBoarding_H4,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!.onBoarding_T4,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.gray2,
                  ),
                ),
                SizedBox(height: 128,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Terms of Use",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500, color: Colors.gray2, decoration: TextDecoration.underline, decorationColor: Colors.gray2)
                    ),
                    SizedBox(width: 6,),
                    SvgPicture.asset(
                      "assets/icons/ellipse.svg",
                      width: 10,
                      height: 10,
                      colorFilter: ColorFilter.mode(Colors.gray2, BlendMode.srcIn),
                    ),
                    SizedBox(width: 6,),
                    Text(
                        "Privacy Policy",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500, color: Colors.gray2, decoration: TextDecoration.underline, decorationColor: Colors.gray2)
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}