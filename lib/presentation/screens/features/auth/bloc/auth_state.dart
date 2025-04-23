import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class PinVerificationSuccess extends AuthState {}

class PinVerificationFailed extends AuthState {
  final String errorMessage;
  PinVerificationFailed(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class PinChangeSuccess extends AuthState {}

class PinChangeFailed extends AuthState {
  final String errorMessage;
  PinChangeFailed(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class NewPinCreated extends AuthState {}

class BiometricState extends AuthState {
  final bool isAvailable;
  final bool isEnabled;
  BiometricState({required this.isAvailable, required this.isEnabled});

  @override
  List<Object?> get props => [isAvailable, isEnabled];
}

class BiometricAuthSuccess extends AuthState {}

class BiometricAuthFailed extends AuthState {
  final String errorMessage;
  BiometricAuthFailed(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class PinRemoved extends AuthState {}

class PinExistsState extends AuthState {
  final bool exists;
  PinExistsState(this.exists);

  @override
  List<Object?> get props => [exists];
}