import 'package:authenticator_app/core/config/theme.dart';
import 'package:authenticator_app/presentation/screens/onboarding/onboarding_screen_1.dart';
import 'package:authenticator_app/presentation/screens/onboarding/paywall_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/config/secure_storage_keys.dart';
import '../../widgets/config_button.dart';
import '../../widgets/continue_btn.dart';
import 'onboarding_screen_2.dart';
import 'onboarding_screen_3.dart';
import 'onboarding_screen_4.dart';

class OnBoardingScreen extends StatefulWidget{
  const OnBoardingScreen ({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
PageController _controller = PageController();
double _progress = 0.0;

@override
void initState() {
  super.initState();

  final storage = FlutterSecureStorage();
  storage.write(key: SecureStorageKeys.isFirst, value: 'false');

  _controller.addListener(() {
    setState(() {
      _progress = (_controller.page ?? 0) / 3;
    });
  });
}


void btnPress() {
  if (_controller.page == 3) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PaywallScreen(isFirst: true))
    );
  } else {
    _controller.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInSine,
    );
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        PageView(
          controller: _controller,
          children: [
            OnBoardingScreen1(),
            OnBoardingScreen2(),
            OnBoardingScreen3(),
            OnBoardingScreen4(controller: _controller, isFirst: true),
          ],
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(43.56),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(43.56),
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 65, right: 16, left: 16),
                  child:  SizedBox(
                    width: double.infinity,
                    child: ContinueBtn(
                      onPressed: btnPress,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}
