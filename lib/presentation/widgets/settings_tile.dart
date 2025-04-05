import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/config/theme.dart' as AppColors;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback? onTap;
  final String? trailingIconPath;
  final bool isLast;

  const SettingsTile({
    Key? key,
    required this.iconPath,
    required this.title,
    required this.isLast,
    this.trailingIconPath,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      iconPath,
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(AppColors.mainBlue, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
                if (trailingIconPath != null)
                  SvgPicture.asset(
                    trailingIconPath!,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(AppColors.mainBlue, BlendMode.srcIn),
                  ),
              ],
            ),
          ),
          if(!isLast) const Divider(height: 1, thickness: 1, color: AppColors.gray2),
        ],
      ),
    );
  }
}
