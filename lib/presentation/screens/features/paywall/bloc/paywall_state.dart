import '../paywall_plan.dart';

class PaywallState {
  final PaywallPlan selectedPlan;
  final bool isTrialEnabled;
  final bool isContinueButtonEnabled;

  PaywallState({
    required this.selectedPlan,
    required this.isTrialEnabled,
    required this.isContinueButtonEnabled,
  });

  PaywallState.initial()
      : selectedPlan = PaywallPlan.none,
        isTrialEnabled = false,
        isContinueButtonEnabled = false;

  PaywallState copyWith({
    PaywallPlan? selectedPlan,
    bool? isTrialEnabled,
    bool? isContinueButtonEnabled,
  }) {
    return PaywallState(
      selectedPlan: selectedPlan ?? this.selectedPlan,
      isTrialEnabled: isTrialEnabled ?? this.isTrialEnabled,
      isContinueButtonEnabled: isContinueButtonEnabled ?? this.isContinueButtonEnabled,
    );
  }
}