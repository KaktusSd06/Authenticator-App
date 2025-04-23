import 'dart:io';
import 'package:authenticator_app/core/config/secure_storage_keys.dart';
import 'package:authenticator_app/presentation/screens/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/config/theme.dart' as AppColors;
import '../../data/models/auth_token.dart';
import '../../data/repositories/remote/synchronize_repository.dart';
import '../../data/repositories/remote/token_repository.dart';
import '../../logic/blocs/tokens/tokens_bloc.dart';
import '../../logic/blocs/tokens/tokens_event.dart';
import '../widgets/settings_tile.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/paywall/paywall_screen.dart';

class PremiumFeaturesScreen extends StatefulWidget {
  @override
  _PremiumFeaturesScreenState createState() => _PremiumFeaturesScreenState();
}

class _PremiumFeaturesScreenState extends State<PremiumFeaturesScreen> with SingleTickerProviderStateMixin {
  late bool isSync = false;
  bool _isLoading = true;
  bool _isAuthValue = false;
  bool _isPremiumValue = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final storage = FlutterSecureStorage();
      String? isAuth = await storage.read(key: SecureStorageKeys.idToken);
      String? isSynchronize = await storage.read(key: SecureStorageKeys.usSync);
      String? isPremium = await storage.read(key: SecureStorageKeys.subscription);

      if (mounted) {
        setState(() {
          _isAuthValue = isAuth != null;
          isSync = isSynchronize != null;
          _isPremiumValue = isPremium != null;
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

  Future<File> _getUserInfoFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/user_info.json');
  }

  void _toggleSync(bool value) async {
    final storage = FlutterSecureStorage();

    if (value) {
      await storage.write(key: SecureStorageKeys.usSync, value: 'true');
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await SynchronizeRepository().startSynchronize(user.uid);

        final file = await _getUserInfoFile();

        List<AuthToken> tokens = [];
        if (await file.exists()) {
          final content = await file.readAsString();
          if (content.isNotEmpty) {
            tokens = AuthToken.listFromJson(content);
          }
        }

        final storage = FlutterSecureStorage();
        String? idToken = await storage.read(key: SecureStorageKeys.idToken);

        if (idToken != null) {
          if(await SynchronizeRepository().isSynchronizing(user.uid)) {
            await TokenService().saveTokensForUser(user.uid, tokens);
          }
        }
      }
    }
else {
      await storage.delete(key: SecureStorageKeys.usSync);

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await SynchronizeRepository().cancelSynchronize(user.uid);
      }
    }

    setState(() {
      isSync = value;
    });
  }

  Future<void> _signOut() async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(AppLocalizations.of(context)!.sign_out, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700),),
        content: Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: AppColors.blue),),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context)!.sign_out, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldSignOut == true) {
      final storage = FlutterSecureStorage();
        await storage.delete(key: SecureStorageKeys.idToken);
      await storage.delete(key: SecureStorageKeys.accessToken);
      await storage.delete(key: SecureStorageKeys.subscription);
      await storage.delete(key: SecureStorageKeys.nextbilling);

      String? isSynchronize = await storage.read(key: SecureStorageKeys.usSync);
      if(isSynchronize == "true") {
        context.read<TokensBloc>().add(DeleteAllTokens());
      }

      if (mounted) {
        setState(() {
          _isAuthValue = false;
        });
      }
    }
  }

  Future<void> _deleteAccount() async {
    final storage = FlutterSecureStorage();
    await storage.deleteAll();

    if (mounted) {
      setState(() {
        _isAuthValue = false;
        _isPremiumValue = false;
      });
    }

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => OnBoardingScreen()),
            (Route<dynamic> route) => false
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          AppLocalizations.of(context)!.premium_features,
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

      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
            padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
            child: _buildContent(),
          ),

    );
  }

  Widget _buildContent() {
    if(!_isAuthValue){
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
                iconPath: "assets/icons/sign_in.svg",
                title: AppLocalizations.of(context)!.signin,
                trailingIconPath: "assets/icons/ic_24.svg",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                },
                isLast: true,
              ),
            ),
          ),
        ],
      );
    }
    if (_isAuthValue && !_isPremiumValue) {
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
        ],
      );

    }
    else{
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
                  // Sign Out Option
                  SettingsTile(
                    iconPath: "assets/icons/sign_in.svg",
                    title: AppLocalizations.of(context)!.sign_out,
                    trailingIconPath: "assets/icons/ic_24.svg",
                    onTap: _signOut,
                    isLast: false,
                  ),

                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/sync.svg",
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(Theme.of(context).brightness == Brightness.light ? Colors.blue : Colors.lightBlue, BlendMode.srcIn),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context)!.synchronize,
                                  style: Theme.of(context).textTheme.headlineLarge,
                                ),
                              ],
                            ),
                            Switch(
                              value: isSync,
                              onChanged: (value) {
                                setState(() {
                                  _toggleSync(value);
                                });
                              },
                              activeColor: Colors.white,
                              activeTrackColor: AppColors.blue,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Color(0xFFD9D9D9),
                              trackOutlineColor: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  return states.contains(MaterialState.selected)
                                      ?  AppColors.mainBlue
                                      :  AppColors.gray4;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, thickness: 1, color: Theme.of(context).brightness == Brightness.light ? AppColors.gray2 : AppColors.gray6),
                    ],
                  ),

                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(AppLocalizations.of(context)!.delete_account, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700),),
                              content: Text(AppLocalizations.of(context)!.delete_account_confirm),
                              backgroundColor: Theme.of(context).cardColor,
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: AppColors.blue),),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _deleteAccount();
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.delete,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/delete.svg",
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(Color(0xFFE33C3C), BlendMode.srcIn),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.delete_account,
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Color(0xFFE33C3C)),
                            ),
                          ],
                        ),
                      )

                  ),
                ],
              ),
            ),
          ),

          if (!_isPremiumValue)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: AppColors.white,
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
                      ).then((_) => _loadData());
                    },
                    isLast: true,
                  ),
                ),
              ),
            ),
        ],
      );
    }
  }
}