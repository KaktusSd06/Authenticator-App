import 'package:authenticator_app/presentation/screens/about_app.dart';
import 'package:authenticator_app/presentation/screens/privacy_policy_screen.dart';
import 'package:authenticator_app/presentation/screens/subscription.dart';
import 'package:authenticator_app/presentation/screens/terms_of_use_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/settings_tile.dart';
import 'features/auth/password_security_screen.dart';
import 'features/premium_features/premium_features.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  InfoScreenSate createState() => InfoScreenSate();
}

class InfoScreenSate extends State<InfoScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'stepanukdima524@gmail.com',
      queryParameters: {
        'subject': AppLocalizations.of(context)!.feedback,
      },
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        _showNoEmailClientToast();
      }
    } catch (e) {
      _showNoEmailClientToast();
    }
  }

  void _showNoEmailClientToast() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.no_email_client_found),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.1 * 255).round()),
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
                      onTap: _sendEmail,
                      isLast: false,
                    ),
                    SettingsTile(
                      iconPath: "assets/icons/doc.svg",
                      title: AppLocalizations.of(context)!.privacy_policy,
                      trailingIconPath: "assets/icons/ic_24.svg",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrivacyPolicyScreen(),
                          ),
                        );
                      },
                      isLast: false,
                    ),
                    SettingsTile(
                      iconPath: "assets/icons/doc.svg",
                      title: AppLocalizations.of(context)!.terms_of_use,
                      trailingIconPath: "assets/icons/ic_24.svg",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TermsOfUseScreen(),
                          ),
                        );
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
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.1 * 255).round()),
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
                          MaterialPageRoute(
                            builder: (context) => AboutAppScreen(),
                          ),
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
                          MaterialPageRoute(
                            builder: (context) => PasswordSecurityScreen(),
                          ),
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
                          MaterialPageRoute(
                            builder: (context) => SubscriptionScreen(),
                          ),
                        );
                      },
                      isLast: false,
                    ),
                    SettingsTile(
                      iconPath: "assets/icons/premium.svg",
                      title: AppLocalizations.of(context)!.premium_features,
                      trailingIconPath: "assets/icons/ic_24.svg",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PremiumFeaturesScreen(),
                          ),
                        );
                      },
                      isLast: true,
                    ),
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
