import 'dart:io';

import 'package:authenticator_app/core/config/secure_storage_keys.dart';
import 'package:authenticator_app/data/repositories/remote/synchronize_repository.dart';
import 'package:authenticator_app/presentation/screens/home_screen.dart';
import 'package:authenticator_app/presentation/screens/privacy_policy_screen.dart';
import 'package:authenticator_app/presentation/screens/terms_of_use_screen.dart';
import 'package:authenticator_app/services/auth_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

import '../../../core/config/theme.dart' as Colors;
import '../../data/models/auth_token.dart';
import '../../data/repositories/remote/subscription_repository.dart';
import '../../data/repositories/remote/token_repository.dart';
import '../dialogs/error_dialog.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isAgree = false;
  bool showErrorMessage = false;

  Future<File> _getUserInfoFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/user_info.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.light ? Colors.mainBlue : Colors.blue,
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgPicture.asset(
            "assets/icons/arrow_back.svg",
            width: 6,
            height: 12,
            colorFilter: ColorFilter.mode(
              Theme.of(context).brightness == Brightness.light ? Colors.mainBlue : Colors.blue,
              BlendMode.srcIn,
            ),
          ),
        ),
        backgroundColor:
            Theme.of(context).brightness == Brightness.light ? Colors.gray1 : Colors.black,
        title: Text(
          AppLocalizations.of(context)!.signin,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
            color:
                Theme.of(context).brightness == Brightness.light ? Color(0xFF171818) : Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.wellcome,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color:
                    Theme.of(context).brightness == Brightness.light
                        ? Colors.mainBlue
                        : Colors.blue,
              ),
            ),
            SizedBox(height: 60),

            SizedBox(
              height: 54,
              child: SignInButton(
                buttonType: ButtonType.google,
                onPressed:
                    isAgree
                        ? () async {
                          if (isAgree) {
                            ConnectivityResult connectivityResult =
                                await Connectivity().checkConnectivity();

                            if (connectivityResult == ConnectivityResult.none) {
                              ErrorDialog().showErrorDialog(
                                context,
                                AppLocalizations.of(context)!.connection_error,
                                AppLocalizations.of(context)!.connection_error_message,
                              );
                              return;
                            }

                            UserCredential? userCredential = await AuthService().signInWithGoogle();

                            if (userCredential != null) {
                              final user = FirebaseAuth.instance.currentUser;

                              if (user != null) {
                                final info = await SubscriptionRepository().loadSubscriptionForUser(
                                  user.uid,
                                );

                                if (info != null) {
                                  final FlutterSecureStorage storage = FlutterSecureStorage();

                                  var email = info['email'];
                                  var plan = info['plan'];
                                  var nextBilling = info['nextBilling'];
                                  var hasFreeTrial = info['hasFreeTrial'];

                                  await storage.write(
                                    key: SecureStorageKeys.hasFreeTrial,
                                    value: hasFreeTrial.toString(),
                                  );
                                  await storage.write(
                                    key: SecureStorageKeys.subscription,
                                    value: plan,
                                  );
                                  await storage.write(
                                    key: SecureStorageKeys.nextbilling,
                                    value: nextBilling,
                                  );

                                  print(
                                    'Subscription info: $email, $plan, $nextBilling, Free Trial: $hasFreeTrial',
                                  );
                                } else {
                                  print('No subscription data found.');
                                }
                              } else {
                                print('User is not logged in.');
                              }

                              try {
                                final user = FirebaseAuth.instance.currentUser;

                                if (user != null) {
                                  if (await SynchronizeRepository().isSynchronizing(user.uid)) {
                                    final tokens = await TokenService().loadTokensForUser(user.uid);
                                    final jsonString = AuthToken.listToJson(tokens);
                                    final file = await _getUserInfoFile();
                                    await file.writeAsString(jsonString);
                                  }
                                }
                              } catch (e) {}

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => HomeScreen()),
                                (Route<dynamic> route) => false,
                              );
                            } else {
                              ErrorDialog().showErrorDialog(
                                context,
                                AppLocalizations.of(context)!.error_with_signIn,
                                AppLocalizations.of(context)!.error_signIn_message,
                              );
                            }
                          } else {
                            setState(() {
                              showErrorMessage = true;
                            });
                          }
                        }
                        : null,
              ),
            ),

            SizedBox(height: 20),

            if (!showErrorMessage) SizedBox(height: 170) else SizedBox(height: 80),
            Visibility(
              visible: showErrorMessage,
              child: Container(
                height: 50,
                padding: EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  color: Colors.gray2.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.term_error,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.gray2),
                      onPressed: () {
                        setState(() {
                          showErrorMessage = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            if (showErrorMessage) SizedBox(height: 40),

            SizedBox(height: 10),

            Row(
              children: [
                Checkbox(
                  value: isAgree,
                  onChanged: (value) {
                    setState(() {
                      isAgree = !isAgree;
                      if (isAgree) showErrorMessage = false;
                    });
                  },
                  activeColor: Colors.mainBlue,
                  checkColor: Colors.white,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      children: [
                        TextSpan(text: AppLocalizations.of(context)!.terms_of_app + ' '),
                        TextSpan(
                          text: AppLocalizations.of(context)!.terms_of_service,
                          style: TextStyle(color: Colors.blue),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => TermsOfUseScreen()),
                                  );
                                },
                        ),
                        TextSpan(text: ' ${AppLocalizations.of(context)!.and} '),
                        TextSpan(
                          text: AppLocalizations.of(context)!.privacy_policy,
                          style: TextStyle(color: Colors.blue),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
                                  );
                                },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
