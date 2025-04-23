import 'package:authenticator_app/core/config/secure_storage_keys.dart';
import 'package:authenticator_app/presentation/screens/features/sign_in/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../core/config/theme.dart' as AppColors;
import '../../data/repositories/remote/subscription_repository.dart';
import '../widgets/btn_with_stoke.dart';
import '../widgets/settings_tile.dart';
import 'features/paywall/paywall_screen.dart';

class MyRouteObserver extends NavigatorObserver {
  final Function onRoutePop;

  MyRouteObserver(this.onRoutePop);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onRoutePop();
    super.didPop(route, previousRoute);
  }
}

class SubscriptionScreen extends StatefulWidget {
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> with WidgetsBindingObserver {
  bool _isLoading = true;
  bool _isPremiumValue = false;
  bool _isAuth = false;
  String _subscriptionType = '';
  String _billingDate = '';
  final RouteObserver<PageRoute> _routeObserver = RouteObserver<PageRoute>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
  }

  final storage = FlutterSecureStorage();

  Future<void> clearSubscriptionData() async {
    await storage.delete(key: SecureStorageKeys.subscription);
    await storage.delete(key: SecureStorageKeys.nextbilling);
    await storage.delete(key: SecureStorageKeys.hasFreeTrial);

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid ?? '';
      SubscriptionRepository().cancelSubscription(userId);
      _loadData();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final isPremiumResult = await _isPremium();
      String subscriptionResult = 'none';
      String billingDateResult = 'none';

      if (isPremiumResult) {
        subscriptionResult = await _getSubscription();
        billingDateResult = await _getBillingDate();
      }

      final storage = FlutterSecureStorage();
      String? isAuth = await storage.read(key: SecureStorageKeys.idToken);

      if (mounted) {
        setState(() {
          _isAuth = isAuth == null ? false : true;
          _isPremiumValue = isPremiumResult;
          _subscriptionType = subscriptionResult;
          _billingDate = billingDateResult;
          _isLoading = false;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          AppLocalizations.of(context)!.subscription,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset(
            "assets/icons/arrow_back.svg",
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              Theme.of(context).brightness == Brightness.light ? AppColors.mainBlue : Colors.blue,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {

    if (!_isAuth) {
      return Column(
        children: [
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
              ],),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: SettingsTile(
                iconPath: "assets/icons/sign_in.svg",
                title: AppLocalizations.of(context)!.signin,
                trailingIconPath: "assets/icons/ic_24.svg",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInScreen()));
                },
                isLast: true,
              ),
            ),
          ),
        ],
      );
    }
    else if(_isAuth && !_isPremiumValue){
      return Column(
        children: [
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
              child: SettingsTile(
                iconPath: "assets/icons/choose_a_plan.svg",
                title: AppLocalizations.of(context)!.choose_a_plan,
                trailingIconPath: "assets/icons/ic_24.svg",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaywallScreen())
                  ).then((_) => _loadData()); // Refresh data when returning from PaywallScreen
                },
                isLast: true,
              ),
            ),
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: BtnWithStoke(
              onPressed: () {
                _loadData();
              },
              text: AppLocalizations.of(context)!.restore_purchases,
            ),
          ),
        ],
      );
    }
    else {
      return Column(
          children: [
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
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(context)!.current_plan,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).brightness == Brightness.light ? Color(0xFF272E3B) : AppColors.white  ),
                            ),
                            TextSpan(text: ' '),
                            TextSpan(
                              text: _subscriptionType,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).brightness == Brightness.light ? Color(0xFF272E3B) : AppColors.white  ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: AppLocalizations.of(context)!.billing_date,
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    color: Theme.of(context).brightness == Brightness.light ? AppColors.gray6 : AppColors.gray4,
                                    fontWeight: FontWeight.w400
                                )
                            ),
                            TextSpan(text: ' '),
                            TextSpan(
                                text: _billingDate,
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    color: Theme.of(context).brightness == Brightness.light ? AppColors.gray6 : AppColors.gray4,
                                    fontWeight: FontWeight.w400
                                )
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: BtnWithStoke(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaywallScreen())
                  ).then((_) => _loadData());
                },
                text: AppLocalizations.of(context)!.change_plan,
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  clearSubscriptionData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Colors.red, width: 2)
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.cancel_plan,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ]
      );
    }

  }

  Future<bool> _isPremium() async {
    final storage = FlutterSecureStorage();
    String? isPremium = await storage.read(key: SecureStorageKeys.subscription);
    return isPremium != null;
  }

  Future<String> _getSubscription() async {
    final storage = FlutterSecureStorage();
    String? subscription = await storage.read(key: SecureStorageKeys.subscription);
    if (subscription != null) {
      if (subscription == "trial") {
        return AppLocalizations.of(context)!.free_trial;
      } else if (subscription == "year") {
        return AppLocalizations.of(context)!.year_subscription;
      } else if (subscription == "week") {
        return AppLocalizations.of(context)!.weekly_subscription;
      }
    }
    return "none";
  }

  Future<String> _getBillingDate() async {
    final storage = FlutterSecureStorage();
    String? billing = await storage.read(key: SecureStorageKeys.nextbilling);
    if (billing != null) {
      DateTime date = DateFormat("dd.MM.yyyy").parse(billing);
      String locale = Intl.getCurrentLocale();
      String formattedDate = DateFormat("MMMM dd, yyyy", locale).format(date);
      return formattedDate;
    }
    return "none";
  }
}