import 'package:authenticator_app/core/config/secure_storage_keys.dart';
import 'package:authenticator_app/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/config/theme.dart' as AppColors;


class LockScreen extends StatefulWidget {
  final Function(bool)? onUnlocked;
  final VoidCallback? onAuthenticated;

  const LockScreen({Key? key, this.onUnlocked, this.onAuthenticated}) : super(key: key);

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final int _pinLength = 4;
  final List<String> _enteredPin = [];
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isAuthenticating = false;
  String _errorMessage = '';
  Timer? _errorTimer;
  bool _isBiometrics = false;
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  @override
  void dispose() {
    _errorTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkBiometricAvailability() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    List<BiometricType> availableBiometrics = [];

    if (canCheckBiometrics) {
      availableBiometrics = await _localAuth.getAvailableBiometrics();
    }

    String? biometricEnabled = await _secureStorage.read(key: SecureStorageKeys.biometric_enabled);

    if (mounted) {
      setState(() {
        _biometricEnabled = biometricEnabled == 'true';
        _isBiometrics = biometricEnabled == 'true' && availableBiometrics.isNotEmpty;
      });
    }

    if (_isBiometrics) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
        }
      });
    }
  }

  void _onSuccessfulAuthentication() {
    if (widget.onAuthenticated != null) {
      widget.onAuthenticated!();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      String biometricPrompt = AppLocalizations.of(context)?.authenticate_with_biometrics ??
          'Авторизуйтесь для входу в додаток';

      bool authenticated = await _localAuth.authenticate(
        localizedReason: biometricPrompt,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (authenticated && mounted) {
        if (widget.onUnlocked != null) {
          widget.onUnlocked!(true);
        }
        _onSuccessfulAuthentication();
      }

    } catch (e) {
      if (e.toString().contains('canceled') || e.toString().contains('cancelled')) {
      } else {
        print('Помилка біометричної автентифікації: $e');
        if (mounted) {
          setState(() {
            _errorMessage = AppLocalizations.of(context)?.biometric_error ?? 'Помилка біометричної автентифікації';
          });

          _errorTimer?.cancel();
          _errorTimer = Timer(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _errorMessage = '';
              });
            }
          });
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  Future<void> _enableBiometrics() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    List<BiometricType> availableBiometrics = [];

    if (canCheckBiometrics) {
      availableBiometrics = await _localAuth.getAvailableBiometrics();
    }

    if (availableBiometrics.isEmpty) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)?.biometric_not_available ??
            'Біометрика недоступна на цьому пристрої';
      });

      _errorTimer?.cancel();
      _errorTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _errorMessage = '';
          });
        }
      });

      return;
    }

    await _secureStorage.write(key: SecureStorageKeys.biometric_enabled, value: 'true');
    if (mounted) {
      setState(() {
        _biometricEnabled = true;
        _isBiometrics = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.biometric_enabled ??
              'Біометричну автентифікацію увімкнено'),
          backgroundColor: Colors.green,
        ),
      );

      _authenticateWithBiometrics();
    }
  }

  void _addDigit(String digit) {
    if (_enteredPin.length < _pinLength) {
      setState(() {
        _enteredPin.add(digit);
        _errorMessage = '';
      });

      if (_enteredPin.length == _pinLength) {
        _verifyPin();
      }
    }
  }

  void _removeDigit() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin.removeLast();
        _errorMessage = '';
      });
    }
  }

  Future<void> _verifyPin() async {
    String enteredPin = _enteredPin.join();
    String? storedPin = await _secureStorage.read(key: SecureStorageKeys.app_pin);

    if (storedPin == null) {
      await _secureStorage.write(key: SecureStorageKeys.app_pin, value: enteredPin);
      if (widget.onUnlocked != null) {
        widget.onUnlocked!(true);
      }
      _onSuccessfulAuthentication();
    } else if (enteredPin == storedPin) {
      if (widget.onUnlocked != null) {
        widget.onUnlocked!(true);
      }
      _onSuccessfulAuthentication();
    } else {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.incorrect_pin;
        _enteredPin.clear();
      });

      _errorTimer?.cancel();
      _errorTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _errorMessage = '';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/lock_screen_background.png',
                fit: BoxFit.cover,
              ),
            ),

            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.lock_outline,
                        size: 40,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context)!.enter_pin,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pinLength,
                          (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index < _enteredPin.length
                              ? Theme.of(context).primaryColor
                              : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  const Spacer(),
                  // PIN pad
                  _buildPinPad(),
                  const SizedBox(height: 16),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinPad() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildPinRow(['1', '2', '3']),
          const SizedBox(height: 16),
          _buildPinRow(['4', '5', '6']),
          const SizedBox(height: 16),
          _buildPinRow(['7', '8', '9']),
          const SizedBox(height: 16),
          _buildPinRow(['del', '0', 'bio']),
        ],
      ),
    );
  }

  Widget _buildPinRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((digit) {
        if (digit == '') {
          return const SizedBox(width: 80);
        } else if (digit == 'del') {
          return _buildDeleteButton();
        } else if (digit == 'bio') {
          return _buildBiometricButton();
        } else {
          return _buildDigitButton(digit);
        }
      }).toList(),
    );
  }

  Widget _buildDigitButton(String digit) {
    return InkWell(
      onTap: () => _addDigit(digit),
      customBorder: const CircleBorder(),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).brightness == Brightness.light ? AppColors.white.withOpacity(0.3) : AppColors.gray6.withOpacity(0.3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            digit,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return InkWell(
      onTap: _removeDigit,
      customBorder: const CircleBorder(),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).brightness == Brightness.light ? AppColors.white.withOpacity(0.1) : AppColors.gray6.withOpacity(0.1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.backspace_outlined,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricButton() {
    return InkWell(
      onTap: () async {
        if (_biometricEnabled) {
          _authenticateWithBiometrics();
        } else {
          _enableBiometrics();
        }
      },
      customBorder: const CircleBorder(),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).brightness == Brightness.light ? AppColors.white.withOpacity(0.1) : AppColors.gray6.withOpacity(0.1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.fingerprint,
            size: 28,
          ),
        ),
      ),
    );
  }
}