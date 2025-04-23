import 'package:flutter/material.dart';
import '../../../../core/config/theme.dart' as app_colors;

class PlanOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final String? badgeText;

  const PlanOption({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          border: Border.all(
            color: selected ? Color(0xFF094086) : app_colors.gray2,
            width: 3,
          ),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: selected ? app_colors.blue : Color(0xFF2A313E),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Color(0xFF2A313E),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.5, color: Color(0xFF094086)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: selected
                      ? Center(
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Color(0xFF094086),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                      : null,
                ),
              ],
            ),
            if (badgeText != null && selected)
              Positioned(
                top: -20,
                right: 40,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFF094086),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    badgeText!,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
