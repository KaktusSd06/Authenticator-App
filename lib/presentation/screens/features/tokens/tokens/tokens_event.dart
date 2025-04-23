import '../../../../../data/models/auth_token.dart';

abstract class TokensEvent {}

class LoadTokens extends TokensEvent {}

class FilterTokens extends TokensEvent {
  final String query;
  FilterTokens(this.query);
}

class DeleteToken extends TokensEvent {
  final AuthToken token;
  DeleteToken(this.token);
}

class AddToken extends TokensEvent {
  final AuthToken token;
  AddToken(this.token);
}

class UpdateToken extends TokensEvent {
  final AuthToken token;
  UpdateToken(this.token);
}

class DeleteAllTokens extends TokensEvent {}

