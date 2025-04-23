import 'package:flutter/material.dart';
import '../../../../core/config/theme.dart' as app_colors;

class OnboardingScreenTemplate extends StatelessWidget {
  final String imagePath;
  final String mainText;
  final String smallText;

  const OnboardingScreenTemplate({
    super.key,
    required this.imagePath,
    required this.mainText,
    required this.smallText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 165, right: 16, left: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              mainText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              smallText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w400,
                color: app_colors.gray2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
