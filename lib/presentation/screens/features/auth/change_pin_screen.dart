import 'dart:async';
import 'package:authenticator_app/presentation/screens/features/auth/pin_change_steps_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/config/theme.dart' as app_colors;
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../auth/bloc/auth_state.dart';

class ChangePinScreen extends StatefulWidget {
  final Function(bool)? onPinChanged;

  const ChangePinScreen({super.key, this.onPinChanged});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final int _pinLength = 4;
  final List<String> _oldPin = [];
  final List<String> _newPin = [];
  final List<String> _confirmPin = [];

  PinChangeStep _currentStep = PinChangeStep.enterOldPin;
  String _errorMessage = '';
  Timer? _errorTimer;

  @override
  void dispose() {
    _errorTimer?.cancel();
    super.dispose();
  }

  void _addDigit(String digit) {
    setState(() {
      _errorMessage = '';
    });

    switch (_currentStep) {
      case PinChangeStep.enterOldPin:
        if (_oldPin.length < _pinLength) {
          setState(() {
            _oldPin.add(digit);
          });

          if (_oldPin.length == _pinLength) {
            _verifyOldPin();
          }
        }
        break;
      case PinChangeStep.enterNewPin:
        if (_newPin.length < _pinLength) {
          setState(() {
            _newPin.add(digit);
          });

          if (_newPin.length == _pinLength) {
            setState(() {
              _currentStep = PinChangeStep.confirmNewPin;
            });
          }
        }
        break;
      case PinChangeStep.confirmNewPin:
        if (_confirmPin.length < _pinLength) {
          setState(() {
            _confirmPin.add(digit);
          });

          if (_confirmPin.length == _pinLength) {
            _verifyAndSaveNewPin();
          }
        }
        break;
    }
  }

  void _removeDigit() {
    setState(() {
      _errorMessage = '';

      switch (_currentStep) {
        case PinChangeStep.enterOldPin:
          if (_oldPin.isNotEmpty) _oldPin.removeLast();
          break;
        case PinChangeStep.enterNewPin:
          if (_newPin.isNotEmpty) _newPin.removeLast();
          break;
        case PinChangeStep.confirmNewPin:
          if (_confirmPin.isNotEmpty) _confirmPin.removeLast();
          break;
      }
    });
  }

  void _verifyOldPin() {
    String enteredOldPin = _oldPin.join();

    // Use AuthBloc to verify the old PIN
    context.read<AuthBloc>().add(VerifyPinEvent(enteredOldPin));
  }

  void _verifyAndSaveNewPin() {
    String newPin = _newPin.join();
    String confirmPin = _confirmPin.join();

    if (newPin == confirmPin) {
      // Use AuthBloc to change the PIN
      context.read<AuthBloc>().add(ChangePinEvent(_oldPin.join(), newPin));
    } else {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.pins_do_not_match;
        _confirmPin.clear();
      });

      _resetErrorAfterDelay();
    }
  }

  void _resetErrorAfterDelay() {
    _errorTimer?.cancel();
    _errorTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          if (_currentStep == PinChangeStep.confirmNewPin) {
            _currentStep = PinChangeStep.enterNewPin;
            _newPin.clear();
          }
          _errorMessage = '';
        });
      }
    });
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case PinChangeStep.enterOldPin:
        return AppLocalizations.of(context)!.enter_old_pin;
      case PinChangeStep.enterNewPin:
        return AppLocalizations.of(context)!.enter_new_pin;
      case PinChangeStep.confirmNewPin:
        return AppLocalizations.of(context)!.confirm_new_pin;
    }
  }

  List<String> _getCurrentPinList() {
    switch (_currentStep) {
      case PinChangeStep.enterOldPin:
        return _oldPin;
      case PinChangeStep.enterNewPin:
        return _newPin;
      case PinChangeStep.confirmNewPin:
        return _confirmPin;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is PinVerificationSuccess && _currentStep == PinChangeStep.enterOldPin) {
          setState(() {
            _currentStep = PinChangeStep.enterNewPin;
          });
        } else if (state is PinVerificationFailed) {
          setState(() {
            _errorMessage = AppLocalizations.of(context)!.incorrect_pin;
            _oldPin.clear();
          });
          _resetErrorAfterDelay();
        } else if (state is PinChangeSuccess) {
          if (widget.onPinChanged != null) {
            widget.onPinChanged!(true);
          }
          Navigator.pop(context);
        } else if (state is PinChangeFailed) {
          setState(() {
            _errorMessage = state.errorMessage;
            if (_currentStep == PinChangeStep.enterOldPin) {
              _oldPin.clear();
            } else {
              _confirmPin.clear();
            }
          });
          _resetErrorAfterDelay();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            AppLocalizations.of(context)!.change_pin,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        extendBodyBehindAppBar: true,
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
                      _getStepTitle(),
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
                            color: index < _getCurrentPinList().length
                                ? Theme.of(context).primaryColor
                                : Colors.grey.withAlpha((0.3 * 255).round()) ,
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
          color: Theme.of(context).brightness == Brightness.light ?
          app_colors.white.withAlpha((0.3 * 255).round())  :
          app_colors.gray6.withAlpha((0.3 * 255).round()) ,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.05 * 255).round()) ,
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
          color: Theme.of(context).brightness == Brightness.light ?
          app_colors.white.withAlpha((0.1 * 255).round()) :
          app_colors.gray6.withAlpha((0.1 * 255).round()),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.05 * 255).round()) ,
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