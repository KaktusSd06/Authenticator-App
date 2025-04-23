import 'dart:async';

import 'package:authenticator_app/core/config/secure_storage_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/config/theme.dart' as app_colors;
import 'features/onboarding/onboarding_screen.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), _navigateNext);
  }

  Future<void> _navigateNext() async {
    final isFirst = await storage.read(key: SecureStorageKeys.isFirst);

    Widget nextScreen;
    if (isFirst != null) {
      nextScreen = HomeScreen();
    } else {
      nextScreen = OnBoardingScreen();
    }

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => nextScreen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/bg.png', fit: BoxFit.cover),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, bottom: 64),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.authenticator,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: app_colors.white,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.your_digital,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: app_colors.white,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.shield,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: app_colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
