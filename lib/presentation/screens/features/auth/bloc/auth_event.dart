import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class VerifyPinEvent extends AuthEvent {
  final String pin;
  VerifyPinEvent(this.pin);

  @override
  List<Object?> get props => [pin];
}

class SetNewPinEvent extends AuthEvent {
  final String pin;
  SetNewPinEvent(this.pin);

  @override
  List<Object?> get props => [pin];
}

class ChangePinEvent extends AuthEvent {
  final String oldPin;
  final String newPin;
  ChangePinEvent(this.oldPin, this.newPin);

  @override
  List<Object?> get props => [oldPin, newPin];
}

class CheckBiometricAvailabilityEvent extends AuthEvent {}

class ToggleBiometricEvent extends AuthEvent {
  final bool enabled;
  ToggleBiometricEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class AuthenticateWithBiometricsEvent extends AuthEvent {
  final BuildContext context;
  AuthenticateWithBiometricsEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class DeletePinEvent extends AuthEvent {}

class CheckPinExistsEvent extends AuthEvent {}
