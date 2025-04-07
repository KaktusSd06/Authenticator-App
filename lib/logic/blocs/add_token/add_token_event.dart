import 'package:equatable/equatable.dart';

abstract class AddTokenEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServiceSelected extends AddTokenEvent {
  final String serviceName;

  ServiceSelected(this.serviceName);

  @override
  List<Object?> get props => [serviceName];
}

class OtpTypeSelected extends AddTokenEvent {
  final String otpType;

  OtpTypeSelected(this.otpType);

  @override
  List<Object?> get props => [otpType];
}

class AddToken extends AddTokenEvent {
  final String account;
  final String key;

  AddToken({
    required this.account,
    required this.key,
  });

  @override
  List<Object?> get props => [account, key];
}