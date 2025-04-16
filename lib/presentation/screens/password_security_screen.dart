import 'package:authenticator_app/core/config/secure_storage_keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import '../../../core/config/theme.dart' as AppColors;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/settings_tile.dart';
import 'change_pin.dart';
import 'create_pin_screen.dart';

class PasswordSecurityScreen extends StatefulWidget{
  @override
  _PasswordSecurityScreenSate createState() => _PasswordSecurityScreenSate();
}

class _PasswordSecurityScreenSate extends State<PasswordSecurityScreen>{
  late bool _isPassword = false;
  bool _isLoading = false;
  bool _isBiometrics = false;
  bool _isAvailableBiometrics = false;
  final LocalAuthentication _localAuth = LocalAuthentication();


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
      await _checkBiometricAvailability();
      final storage = FlutterSecureStorage();
      String? isPassword = await storage.read(key: SecureStorageKeys.app_pin);
      String? isBiometrics = await storage.read(key: SecureStorageKeys.biometric_enabled);
      if (mounted) {
        setState(() {
          _isPassword = isPassword == null ? false : true;
          _isLoading = false;
          _isBiometrics = isBiometrics == null ? false : true;
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
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: AppColors.mainBlue,
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgPicture.asset(
            "assets/icons/arrow_back.svg",
            width: 6,
            height: 12,
            colorFilter: ColorFilter.mode(AppColors.mainBlue, BlendMode.srcIn),
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.password_security,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        centerTitle: true,
      ),

      body: _isPassword ? _buildBodyWithPassword() : _buildBodyWithOutPassword(),
    );
  }

  _buildBodyWithPassword(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/key.svg",
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(Theme.of(context).brightness == Brightness.light ? AppColors.mainBlue : Colors.blue, BlendMode.srcIn),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context)!.password,
                                  style: Theme.of(context).textTheme.headlineLarge,
                                ),
                              ],
                            ),
                            Switch(
                              value: _isPassword,
                              onChanged: (value) {
                                setState(() {
                                  _isPassword = value;
                                  if(value){
                                    setPassword();
                                  } else{
                                    deletePassword();
                                  }
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
                    padding: const EdgeInsets.only(top: 6),
                    child: SettingsTile(
                      iconPath: "assets/icons/sync.svg",
                      title: AppLocalizations.of(context)!.change_password,
                      trailingIconPath: "assets/icons/ic_24.svg",
                      onTap: _changePassword,
                      isLast: true,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20,),

          _isAvailableBiometrics ?
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/fingerprint.svg",
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(Theme.of(context).brightness == Brightness.light ? AppColors.mainBlue : Colors.blue, BlendMode.srcIn),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.biometrics,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ],
                        ),
                        Switch(
                          value: _isBiometrics,
                          onChanged: (value) {
                            setState(() {
                              _isBiometrics = value;
                              if(value){
                                setBiometrics();
                              }
                              else{
                                deleteBiometrics();
                              }
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
                ],
              ),
            ),
          ) : SizedBox(height: 0,)
        ],
      ),
    );
  }

  _buildBodyWithOutPassword(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              spreadRadius: 2,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/key.svg",
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(Theme.of(context).brightness == Brightness.light ? AppColors.mainBlue : Colors.blue, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.password,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
              Switch(
                value: _isPassword,
                onChanged: (value) {
                  setState(() {
                    _isPassword = value;
                    if(value){
                      setPassword();
                    }
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
      ),
    );
  }

  void setPassword() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePinScreen()),
    );

    final storage = FlutterSecureStorage();
    final hasPin = await storage.containsKey(key: SecureStorageKeys.app_pin);
    if (hasPin) {
      setState(() {
        _isPassword = true;
      });
    } else {
      setState(() {
        _isPassword = false;
      });
    }
  }


  void _changePassword() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePinScreen()));
  }

  Future<void> _checkBiometricAvailability() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    List<BiometricType> availableBiometrics = [];

    if (canCheckBiometrics) {
      availableBiometrics = await _localAuth.getAvailableBiometrics();
    }

    if (availableBiometrics.isNotEmpty) {
      _isAvailableBiometrics = true;
    }
  }

  Future<void> setBiometrics() async {
    final secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: SecureStorageKeys.biometric_enabled, value: 'true');
  }

  Future<void> deletePassword() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: SecureStorageKeys.app_pin);
  }

  Future<void> deleteBiometrics() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: SecureStorageKeys.biometric_enabled);
  }
}
