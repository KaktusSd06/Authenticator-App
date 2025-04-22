import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/config/theme.dart' as app_colors;

class TrialSwitchBlock extends StatelessWidget {
  final bool isTrialEnabled;
  final ValueChanged<bool> onChanged;

  const TrialSwitchBlock({
    super.key,
    required this.isTrialEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isTrialEnabled),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          border: Border.all(
            color: isTrialEnabled ? Color(0xFF094086) : app_colors.gray2,
            width: 3,
          ),
          color: app_colors.white,
        ),
        padding: const EdgeInsets.only(right: 6, left: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)?.free_Trial_Enabled ?? '',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Color(0xFF2A313E),
                fontWeight: FontWeight.w700,
              ),
            ),
            Switch(
              value: isTrialEnabled,
              onChanged: onChanged,
              activeColor: app_colors.white,
              activeTrackColor: Color(0xFF00CF00),
              inactiveThumbColor: app_colors.white,
              inactiveTrackColor: Color(0xFFD9D9D9),
              trackOutlineColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) =>
                states.contains(WidgetState.selected)
                    ? Color(0xFF00CF00)
                    : app_colors.gray2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}