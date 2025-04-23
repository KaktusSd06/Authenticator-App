import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../terms_of_use_screen.dart';
import '../../../../core/config/theme.dart' as app_colors;

class OnBoardingScreenLast extends StatelessWidget {
  final VoidCallback onClosePressed;
  final VoidCallback onRestorePressed;

  const OnBoardingScreenLast({
    super.key,
    required this.onClosePressed,
    required this.onRestorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/onboarding_bg_4.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Top controls
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 23, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: onClosePressed,
                    child: SvgPicture.asset(
                      "assets/icons/x.svg",
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(app_colors.mainBlue, BlendMode.srcIn),
                    ),
                  ),
                  GestureDetector(
                    onTap: onRestorePressed,
                    child: Text(
                      AppLocalizations.of(context)!.restor_l,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: app_colors.mainBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Content
            Padding(
              padding: const EdgeInsets.only(bottom: 28, left: 16, right: 16),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.onBoarding_H4,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: app_colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context)!.onBoarding_T4,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: app_colors.gray2,
                    ),
                  ),
                  const SizedBox(height: 128),

                  // Terms and Privacy
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => TermsOfUseScreen()),
                          );
                        },
                        child: Text(
                          "Terms of Use",
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: app_colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      SvgPicture.asset(
                        "assets/icons/ellipse.svg",
                        width: 4,
                        height: 4,
                        colorFilter: const ColorFilter.mode(app_colors.gray2, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => TermsOfUseScreen()),
                          );
                        },
                        child: Text(
                          "Privacy Policy",
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: app_colors.white,
                            decoration: TextDecoration.underline,
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
