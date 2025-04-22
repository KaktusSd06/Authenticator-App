import '../paywall_plan.dart';

class PaywallEvent {}

class ToggleTrialEvent extends PaywallEvent {
  final bool value;
  ToggleTrialEvent(this.value);
}

class SelectPlanEvent extends PaywallEvent {
  final PaywallPlan plan;
  SelectPlanEvent(this.plan);
}
