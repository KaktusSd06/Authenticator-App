import 'package:authenticator_app/presentation/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import '../../../core/config/theme.dart' as Colors;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../sign_in_screen.dart';
import '../terms_of_use_screen.dart';

class OnBoardingScreen4 extends StatelessWidget {
  final PageController controller;
  final bool isFirst;

  const OnBoardingScreen4({Key? key, required this.controller, required this.isFirst}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/onboarding_bg_4.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 23, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close button
                  GestureDetector(
                    onTap: () {
                      print(isFirst);
                      if(isFirst) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) =>
                                HomeScreen()));
                      }
                      else{
                        Navigator.pop(context);
                      }
                    },
                    child: SvgPicture.asset(
                      "assets/icons/x.svg",
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(Colors.mainBlue, BlendMode.srcIn),
                    ),
                  ),
                  // Restore text button
                  GestureDetector(
                    onTap: () {
                      controller.animateToPage(
                        0,
                        duration: Duration(milliseconds: 800),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.restor_l,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.mainBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Spacer to center content vertically
            Spacer(),

            // Bottom content
            Padding(
              padding: const EdgeInsets.only(bottom: 28, left: 16, right: 16),
              child: Column(
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

                  SizedBox(height: 128),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TermsOfUseScreen())
                          );
                        },
                        child: Text(
                         "Terms of Use",
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.gray2,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.gray2,
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      SvgPicture.asset(
                        "assets/icons/ellipse.svg",
                        width: 4,
                        height: 4,
                        colorFilter: ColorFilter.mode(Colors.gray2, BlendMode.srcIn),
                      ),
                      SizedBox(width: 6),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TermsOfUseScreen()
                              )
                          );
                        },
                        child: Text(
                          "Privacy Policy",
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.gray2,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.gray2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
