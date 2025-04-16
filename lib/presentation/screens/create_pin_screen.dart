import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:async';
import '../../../core/config/theme.dart' as AppColors;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/config/secure_storage_keys.dart';

class CreatePinScreen extends StatefulWidget {
  final Function(bool)? onPinCreated;

  const CreatePinScreen({Key? key, this.onPinCreated}) : super(key: key);

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  final int _pinLength = 4;
  final List<String> _enteredPin = [];
  final List<String> _confirmPin = [];
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _isPinCreated = false;
  bool _isConfirming = false;
  String _errorMessage = '';
  Timer? _errorTimer;

  @override
  void dispose() {
    _errorTimer?.cancel();
    super.dispose();
  }

  void _addDigit(String digit) {
    if (!_isConfirming) {
      if (_enteredPin.length < _pinLength) {
        setState(() {
          _enteredPin.add(digit);
          _errorMessage = '';
        });

        if (_enteredPin.length == _pinLength) {
          setState(() {
            _isConfirming = true;
          });
        }
      }
    } else {
      if (_confirmPin.length < _pinLength) {
        setState(() {
          _confirmPin.add(digit);
          _errorMessage = '';
        });

        if (_confirmPin.length == _pinLength) {
          _verifyAndSavePin();
        }
      }
    }
  }

  void _removeDigit() {
    setState(() {
      if (_isConfirming && _confirmPin.isNotEmpty) {
        _confirmPin.removeLast();
      } else if (!_isConfirming && _enteredPin.isNotEmpty) {
        _enteredPin.removeLast();
      }
      _errorMessage = '';
    });
  }

  Future<void> _verifyAndSavePin() async {
    String initialPin = _enteredPin.join();
    String confirmationPin = _confirmPin.join();

    if (initialPin == confirmationPin) {
      await _secureStorage.write(key: SecureStorageKeys.app_pin, value: initialPin);
      setState(() {
        _isPinCreated = true;
      });

      if (widget.onPinCreated != null) {
        widget.onPinCreated!(true);
      }
      Navigator.pop(context);
    } else {
      setState(() {
        _errorMessage = AppLocalizations.of(context)?.pins_do_not_match ?? 'PIN коди не збігаються';
        _confirmPin.clear();
      });

      _errorTimer?.cancel();
      _errorTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isConfirming = false;
            _enteredPin.clear();
            _errorMessage = '';
          });
        }
      });
    }
  }

  void _setupBiometricAuth() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    if (canCheckBiometrics) {
      await _secureStorage.write(key: SecureStorageKeys.biometric_enabled, value: 'true');
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
                    _isConfirming
                        ? AppLocalizations.of(context)?.confirm_pin ?? 'Підтвердіть PIN'
                        : AppLocalizations.of(context)?.create_pin ?? 'Створіть PIN',
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
                          color: _isConfirming
                              ? (index < _confirmPin.length ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.3))
                              : (index < _enteredPin.length ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.3)),
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
                  _buildPinPad(),
                  const SizedBox(height: 30),
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
          _buildPinRow(['del', '0', '']),
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
}