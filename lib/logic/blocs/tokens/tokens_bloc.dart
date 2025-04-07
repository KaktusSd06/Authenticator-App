import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import '../../../data/models/auth_token.dart';
import 'tokens_event.dart';
import 'tokens_state.dart';

class TokensBloc extends Bloc<TokensEvent, TokensState> {
  TokensBloc() : super(TokensInitial()) {
    on<LoadTokens>(_onLoadTokens);
    on<FilterTokens>(_onFilterTokens);
    on<DeleteToken>(_onDeleteToken);
  }

  Future<File> _getUserInfoFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/user_info.json');
  }

  void _onLoadTokens(LoadTokens event, Emitter<TokensState> emit) async {
    emit(TokensLoading());

    try {
      final file = await _getUserInfoFile();
      List<AuthToken> allTokens = [];

      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          allTokens = AuthToken.listFromJson(content);
        }
      }

      final filteredTokens = allTokens;
      final timeBasedTokens = filteredTokens.where((token) => token.type == AuthTokenType.totp).toList();
      final counterTokens = filteredTokens.where((token) => token.type == AuthTokenType.hotp).toList();

      emit(TokensLoaded(
        allTokens: allTokens,
        filteredTokens: filteredTokens,
        timeBasedTokens: timeBasedTokens,
        counterTokens: counterTokens,
      ));
    } catch (e) {
      emit(TokensError('Error reading: ${e.toString()}'));
    }
  }

  void _onFilterTokens(FilterTokens event, Emitter<TokensState> emit) {
    if (state is TokensLoaded) {
      final currentState = state as TokensLoaded;
      final query = event.query.toLowerCase();

      final filteredTokens = currentState.allTokens.where((token) {
        return token.service.toLowerCase().contains(query) ||
            token.account.toLowerCase().contains(query);
      }).toList();

      final timeBasedTokens = filteredTokens.where((token) => token.type == AuthTokenType.totp).toList();
      final counterTokens = filteredTokens.where((token) => token.type == AuthTokenType.hotp).toList();

      emit(currentState.copyWith(
        filteredTokens: filteredTokens,
        timeBasedTokens: timeBasedTokens,
        counterTokens: counterTokens,
      ));
    }
  }

  void _onDeleteToken(DeleteToken event, Emitter<TokensState> emit) async {
    if (state is TokensLoaded) {
      final currentState = state as TokensLoaded;
      final allTokens = currentState.allTokens
          .where((t) => !(t.service == event.token.service &&
          t.account == event.token.account &&
          t.secret == event.token.secret))
          .toList();

      try {
        final file = await _getUserInfoFile();
        final jsonString = jsonEncode(allTokens.map((token) => token.toJson()).toList());
        await file.writeAsString(jsonString);

        final query = "";
        final filteredTokens = allTokens;
        final timeBasedTokens = filteredTokens.where((token) => token.type == AuthTokenType.totp).toList();
        final counterTokens = filteredTokens.where((token) => token.type == AuthTokenType.hotp).toList();

        emit(TokensLoaded(
          allTokens: allTokens,
          filteredTokens: filteredTokens,
          timeBasedTokens: timeBasedTokens,
          counterTokens: counterTokens,
        ));
      } catch (e) {
        emit(TokensError('Ошибка при удалении токена: ${e.toString()}'));
      }
    }
  }
}