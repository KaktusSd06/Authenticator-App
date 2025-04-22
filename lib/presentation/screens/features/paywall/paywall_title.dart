import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/config/theme.dart' as app_colors;

class PaywallTitleBlock extends StatelessWidget {
  const PaywallTitleBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.paywell_H1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: app_colors.white,
          ),
        ),
        SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.paywell_T1,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w400,
            color: app_colors.gray2,
          ),
        ),
      ],
    );
  }
}