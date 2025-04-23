import 'package:equatable/equatable.dart';

sealed class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object?> get props => [];
}

class LoadSubscription extends SubscriptionEvent {}

class ClearSubscriptionData extends SubscriptionEvent {}

class RestorePurchases extends SubscriptionEvent {}