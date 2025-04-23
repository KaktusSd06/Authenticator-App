import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/config/theme.dart' as app_colors;


class TermsOfUseScreen extends StatefulWidget {
  const TermsOfUseScreen({super.key});

  @override
  TermsOfUseScreenState createState() => TermsOfUseScreenState();
}

class TermsOfUseScreenState extends State<TermsOfUseScreen> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          AppLocalizations.of(context)!.terms_title,
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
              Theme.of(context).brightness == Brightness.light ? app_colors.mainBlue : Colors.blue,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.terms_title,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),

            Text(
              AppLocalizations.of(context)!.terms_intro,
              style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? app_colors.gray6 : app_colors.gray4),
            ),

            SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.usage_rules_title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.usage_rules_desc,
              style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? app_colors.gray6 : app_colors.gray4),
            ),

            SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.limitations_title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.limitations_desc,
              style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? app_colors.gray6 : app_colors.gray4),
            ),

            SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.modifications_title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.modifications_desc,
              style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? app_colors.gray6 : app_colors.gray4),
            ),
          ],
        ),
      ),
    );
  }
}
