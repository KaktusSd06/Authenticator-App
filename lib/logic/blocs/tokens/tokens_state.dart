import '../../../data/models/auth_token.dart';
import 'package:equatable/equatable.dart';

abstract class TokensState extends Equatable {
  final List<AuthToken> allTokens;
  final List<AuthToken> filteredTokens;
  final List<AuthToken> timeBasedTokens;
  final List<AuthToken> counterTokens;

  TokensState(this.allTokens, this.filteredTokens, this.timeBasedTokens, this.counterTokens);

  @override
  List<Object> get props => [allTokens, filteredTokens, timeBasedTokens, counterTokens];
}

class TokensInitial extends TokensState {
  TokensInitial() : super([], [], [], []);
}

class TokensLoading extends TokensState {
  TokensLoading() : super([], [], [], []);
}

class TokensLoaded extends TokensState {
  TokensLoaded({
    required List<AuthToken> allTokens,
    required List<AuthToken> filteredTokens,
    required List<AuthToken> timeBasedTokens,
    required List<AuthToken> counterTokens,
  }) : super(allTokens, filteredTokens, timeBasedTokens, counterTokens);

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

  TokensError(this.message) : super([], [], [], []);
}
