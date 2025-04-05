import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:authenticator_app/presentation/screens/info_screen.dart';
import 'package:authenticator_app/presentation/screens/main_screen.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/config/theme.dart' as AppColors;


class AboutAppScreen extends StatefulWidget {
  @override
  _AboutAppScreenState createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          AppLocalizations.of(context)!.about_app,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset(
            "assets/icons/arrow_back.svg",
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              AppColors.mainBlue,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 24, right: 16, left: 16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child:               Text(
                  AppLocalizations.of(context)!.what_is_app,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),

              SizedBox(height: 16,),

              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: AppLocalizations.of(context)!.authenticator, style: TextStyle(color: Color(0xFF3E3E3E))),
                    TextSpan(text: ' '),
                    TextSpan(
                      text: AppLocalizations.of(context)!.about_p1,
                      style: TextStyle(color: AppColors.gray6),
                    ),
                    TextSpan(
                      text: '\n\n${AppLocalizations.of(context)!.about_p2}',
                      style: TextStyle(color: AppColors.gray6),
                    ),
                    TextSpan(text: ' ${AppLocalizations.of(context)!.authenticator} ', style: TextStyle(color: Color(0xFF3E3E3E))),
                    TextSpan(
                      text: AppLocalizations.of(context)!.about_p3,
                      style: TextStyle(color: AppColors.gray6),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!.about_p4,
                      style: TextStyle(color: AppColors.gray6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
