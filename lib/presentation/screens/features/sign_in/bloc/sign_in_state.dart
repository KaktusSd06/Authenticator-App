import 'package:equatable/equatable.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {}

class SignInFailure extends SignInState {
  final String? errorMessage;

  const SignInFailure({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class SignInTermError extends SignInState {}