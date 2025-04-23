// premium_event.dart
import 'package:flutter/material.dart';

sealed class PremiumFeaturesEvent {}

class LoadPremiumFeatures extends PremiumFeaturesEvent {}

class ToggleSync extends PremiumFeaturesEvent {
  final bool value;
  ToggleSync({required this.value});
}

class SignOut extends PremiumFeaturesEvent {
  final BuildContext context;
  SignOut({required this.context});
}

class DeleteAccount extends PremiumFeaturesEvent {
  final BuildContext context;
  DeleteAccount({required this.context});
}