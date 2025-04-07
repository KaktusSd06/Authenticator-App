import 'dart:convert';

enum AuthTokenType { totp, hotp }

class AuthToken {
  final String service;
  final String account;
  final String secret;
  final AuthTokenType type;
  int? counter;

  AuthToken({
    required this.service,
    required this.account,
    required this.secret,
    required this.type,
    this.counter,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      service: json['service'],
      account: json['account'],
      secret: json['secret'],
      type: json['type'] == 'hotp' ? AuthTokenType.hotp : AuthTokenType.totp,
      counter: json['counter'],
    );
  }

  updateCounter()=> counter = (counter! + 1)!;

  Map<String, dynamic> toJson() {
    return {
      'service': service,
      'account': account,
      'secret': secret,
      'type': type == AuthTokenType.hotp ? 'hotp' : 'totp',
      if (counter != null) 'counter': counter,
    };
  }

  static List<AuthToken> listFromJson(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => AuthToken.fromJson(e)).toList();
  }

  static String listToJson(List<AuthToken> tokens) {
    final List<Map<String, dynamic>> jsonList =
    tokens.map((e) => e.toJson()).toList();
    return json.encode(jsonList);
  }
}
