import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

class SignInWithGoogle extends SignInEvent {
  final BuildContext context;

  const SignInWithGoogle({required this.context});

  @override
  List<Object?> get props => [context];
}

class ShowTermError extends SignInEvent {}

class ClearTermError extends SignInEvent {}