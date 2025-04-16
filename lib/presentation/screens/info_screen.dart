import 'package:authenticator_app/core/config/secure_storage_keys.dart';
import 'package:authenticator_app/presentation/screens/about_app.dart';
import 'package:authenticator_app/presentation/screens/password_security_screen.dart';
import 'package:authenticator_app/presentation/screens/premium_features.dart';
import 'package:authenticator_app/presentation/screens/sign_in_screen.dart';
import 'package:authenticator_app/presentation/screens/subscription.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/settings_tile.dart';


class InfoScreen extends StatefulWidget{
  @override
  _InfoScreenSate createState() => _InfoScreenSate();
}

class _InfoScreenSate extends State<InfoScreen>{
  bool _isAuthValue = false;
  bool _isLoading = false;

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final storage = FlutterSecureStorage();
      String? isAuth = await storage.read(key: SecureStorageKeys.idToken);

      if (mounted) {
        setState(() {
          _isAuthValue = isAuth != null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.customer_support,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            SizedBox(height: 16,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  children: [
                    SettingsTile(
                      iconPath: "assets/icons/contact_us.svg",
                      title: AppLocalizations.of(context)!.contact_us,
                      trailingIconPath: "assets/icons/ic_24.svg",
                      onTap: () {

                      },
                      isLast: false,
                    ),
                    SettingsTile(
                      iconPath: "assets/icons/doc.svg",
                      title: AppLocalizations.of(context)!.privacy_policy,
                      trailingIconPath: "assets/icons/ic_24.svg",
                      onTap: () {

                      },
                      isLast: false,
                    ),
                    SettingsTile(
                      iconPath: "assets/icons/doc.svg",
                      title: AppLocalizations.of(context)!.terms_of_use,
                      trailingIconPath: "assets/icons/ic_24.svg",
                      onTap: () {

                      },
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.usefull_info,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            SizedBox(height: 16,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  children: [
                    SettingsTile(
                      iconPath: "assets/icons/about.svg",
                      title: AppLocalizations.of(context)!.about_app,
                      trailingIconPath: "assets/icons/ic_24.svg",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AboutAppScreen()),
                        );
                      },
                      isLast: false,
                    ),
                    SettingsTile(
                      iconPath: "assets/icons/key.svg",
                      title: AppLocalizations.of(context)!.password_security,
                      trailingIconPath: "assets/icons/ic_24.svg",
                      onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PasswordSecurityScreen())
                          );
                      },
                      isLast: false,
                    ),
                    SettingsTile(
                      iconPath: "assets/icons/subscription.svg",
                      title: AppLocalizations.of(context)!.subscription,
                      trailingIconPath: "assets/icons/ic_24.svg",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SubscriptionScreen()),
                        );
                      },
                      isLast: false,
                    ),
                    SettingsTile(
                      iconPath: "assets/icons/premium.svg",
                      title: AppLocalizations.of(context)!.premium_features,
                      trailingIconPath: "assets/icons/ic_24.svg",
                      onTap: () {
                        if(_isAuthValue){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PremiumFeaturesScreen())
                          );
                        }
                        else{
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignInScreen())
                          );
                        }
                      },
                      isLast: true,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
