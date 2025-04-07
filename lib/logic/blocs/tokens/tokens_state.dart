import '../../../data/models/auth_token.dart';
import 'package:equatable/equatable.dart';

abstract class TokensState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TokensInitial extends TokensState {}

class TokensLoading extends TokensState {}

class TokensLoaded extends TokensState {
  final List<AuthToken> allTokens;
  final List<AuthToken> filteredTokens;
  final List<AuthToken> timeBasedTokens;
  final List<AuthToken> counterTokens;

  TokensLoaded({
    required this.allTokens,
    required this.filteredTokens,
    required this.timeBasedTokens,
    required this.counterTokens,
  });

  @override
  List<Object?> get props => [allTokens, filteredTokens, timeBasedTokens, counterTokens];

  TokensLoaded copyWith({
    List<AuthToken>? allTokens,
    List<AuthToken>? filteredTokens,
    List<AuthToken>? timeBasedTokens,
    List<AuthToken>? counterTokens,
  }) {
    return TokensLoaded(
      allTokens: allTokens ?? this.allTokens,
      filteredTokens: filteredTokens ?? this.filteredTokens,
      timeBasedTokens: timeBasedTokens ?? this.timeBasedTokens,
      counterTokens: counterTokens ?? this.counterTokens,
    );
  }
}

class TokensError extends TokensState {
  final String message;
  TokensError(this.message);

  @override
  List<Object?> get props => [message];
}