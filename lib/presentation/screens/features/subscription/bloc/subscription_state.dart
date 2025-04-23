import 'package:equatable/equatable.dart';

sealed class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final bool isPremium;
  final bool isAuthenticated;
  final String subscriptionType;
  final String billingDate;

  const SubscriptionLoaded({
    required this.isPremium,
    required this.isAuthenticated,
    required this.subscriptionType,
    required this.billingDate,
  });

  @override
  List<Object?> get props => [isPremium, isAuthenticated, subscriptionType, billingDate];
}

class SubscriptionError extends SubscriptionState {
  final String errorMessage;

  const SubscriptionError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}