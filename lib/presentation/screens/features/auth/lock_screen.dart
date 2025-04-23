import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/config/theme.dart' as app_colors;
import '../../home_screen.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';

class LockScreen extends StatefulWidget {
  final Function(bool)? onUnlocked;
  final VoidCallback? onAuthenticated;
  final Function()? onAuthStarted;
  final Function()? onAuthFinished;

  const LockScreen({
    super.key,
    this.onUnlocked,
    this.onAuthenticated,
    this.onAuthStarted,
    this.onAuthFinished,
  });

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final int _pinLength = 4;
  final List<String> _enteredPin = [];
  String _errorMessage = '';
  Timer? _errorTimer;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckBiometricAvailabilityEvent());
  }

  @override
  void dispose() {
    _errorTimer?.cancel();
    super.dispose();
  }

  void _addDigit(String digit) {
    if (_enteredPin.length < _pinLength) {
      setState(() {
        _enteredPin.add(digit);
        _errorMessage = '';
      });

      if (_enteredPin.length == _pinLength) {
        context.read<AuthBloc>().add(VerifyPinEvent(_enteredPin.join()));
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

  void _onSuccessfulAuthentication() {
    if (widget.onAuthenticated != null) {
      widget.onAuthenticated!();
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
    }

    if (widget.onUnlocked != null) {
      widget.onUnlocked!(true);
    }

    if (widget.onAuthFinished != null) {
      widget.onAuthFinished!();
    }
  }

  void _authenticateWithBiometrics() {
    if (widget.onAuthStarted != null) {
      widget.onAuthStarted!();
    }
    context.read<AuthBloc>().add(AuthenticateWithBiometricsEvent(context));
  }

  void _showErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is PinVerificationSuccess || state is BiometricAuthSuccess) {
            _onSuccessfulAuthentication();
          } else if (state is PinVerificationFailed) {
            _showErrorMessage(AppLocalizations.of(context)?.incorrect_pin ?? 'Incorrect PIN');
          } else if (state is BiometricAuthFailed) {
            _showErrorMessage(state.errorMessage);
            if (widget.onAuthFinished != null) {
              widget.onAuthFinished!();
            }
          }
        },
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset('assets/images/lock_screen_background.png', fit: BoxFit.cover),
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
                              color: Colors.black.withAlpha((0.1 * 255).round()),
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
                        AppLocalizations.of(context)?.enter_pin ?? 'Enter PIN',
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
                                  : Colors.grey.withAlpha((0.3 * 255).round()),
                            ),
                          ),
                        ),
                      ),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      const Spacer(),
                      _buildPinPad(),
                      const SizedBox(height: 16),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
          color: Theme.of(context).brightness == Brightness.light
              ? app_colors.white.withAlpha((0.3 * 255).round())
              : app_colors.gray6.withAlpha((0.3 * 255).round()),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha((0.05 * 255).round()), blurRadius: 5, spreadRadius: 1),
          ],
        ),
        child: Center(
          child: Text(
            digit,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
          color: Theme.of(context).brightness == Brightness.light
              ? app_colors.white.withAlpha((0.1 * 255).round())
              : app_colors.gray6.withAlpha((0.1 * 255).round()),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha((0.05 * 255).round()), blurRadius: 5, spreadRadius: 1),
          ],
        ),
        child: const Center(child: Icon(Icons.backspace_outlined, size: 28)),
      ),
    );
  }

  Widget _buildBiometricButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) => current is BiometricState,
      builder: (context, state) {
        bool isBiometricEnabled = false;
        bool isBiometricAvailable = false;

        if (state is BiometricState) {
          isBiometricEnabled = state.isEnabled;
          isBiometricAvailable = state.isAvailable;
        }

        return Visibility(
          visible: isBiometricAvailable,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: InkWell(
            onTap: isBiometricEnabled ? _authenticateWithBiometrics : null,
            customBorder: const CircleBorder(),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).brightness == Brightness.light
                    ? app_colors.white.withAlpha(isBiometricEnabled ? (0.3 * 255).round() : (0.1 * 255).round())
                    : app_colors.gray6.withAlpha(isBiometricEnabled ? (0.3 * 255).round() : (0.1 * 255).round()),
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha((0.05 * 255).round()), blurRadius: 5, spreadRadius: 1),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.fingerprint,
                  size: 28,
                  color: isBiometricEnabled ? null : Colors.grey,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}