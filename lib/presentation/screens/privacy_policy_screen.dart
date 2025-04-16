import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:authenticator_app/presentation/screens/info_screen.dart';
import 'package:authenticator_app/presentation/screens/main_screen.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/config/theme.dart' as AppColors;


class PrivacyPolicyScreen extends StatefulWidget {
  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          AppLocalizations.of(context)!.privacy_policy,
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
              Theme.of(context).brightness == Brightness.light ? AppColors.mainBlue : Colors.blue,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.privacy_title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 16),

          Text(
            AppLocalizations.of(context)!.privacy_intro,
            style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? AppColors.gray6 : AppColors.gray4),
          ),

          SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.data_collection_title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.data_collection_desc,
            style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? AppColors.gray6 : AppColors.gray4),
          ),

          SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.data_usage_title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.data_usage_desc,
            style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? AppColors.gray6 : AppColors.gray4),
          ),

          SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.your_rights_title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.your_rights_desc,
            style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? AppColors.gray6 : AppColors.gray4),
          ),
        ],
            ),
      ),
    );
  }
}
