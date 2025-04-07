import 'package:equatable/equatable.dart';

class AddTokenState extends Equatable {
  final String serviceName;
  final String otpType;

  const AddTokenState({
    this.serviceName = "",
    this.otpType = "Time-based",
  });

  AddTokenState copyWith({
    String? serviceName,
    String? otpType,
  }) {
    return AddTokenState(
      serviceName: serviceName ?? this.serviceName,
      otpType: otpType ?? this.otpType,
    );
  }

  @override
  List<Object?> get props => [serviceName, otpType];
}

class AddTokenInitial extends AddTokenState {
  const AddTokenInitial() : super();
}

class AddTokenLoading extends AddTokenState {
  const AddTokenLoading({
    required String serviceName,
    required String otpType,
  }) : super(serviceName: serviceName, otpType: otpType);
}

class AddTokenSuccess extends AddTokenState {
  const AddTokenSuccess({
    required String serviceName,
    required String otpType,
  }) : super(serviceName: serviceName, otpType: otpType);
}

class AddTokenError extends AddTokenState {
  final String message;

  const AddTokenError({
    required this.message,
    required String serviceName,
    required String otpType,
  }) : super(serviceName: serviceName, otpType: otpType);

  @override
  List<Object?> get props => [message, serviceName, otpType];
}