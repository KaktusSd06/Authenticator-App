abstract class TrialState {}

class TrialInitialState extends TrialState {
  final bool isTrialEnabled;
  final bool yearPlan;
  final bool threeDayPlan;

  TrialInitialState({
    required this.isTrialEnabled,
    required this.yearPlan,
    required this.threeDayPlan,
  });
}

class TrialStateUpdated extends TrialState {
  final bool isTrialEnabled;
  final bool yearPlan;
  final bool threeDayPlan;

  TrialStateUpdated({
    required this.isTrialEnabled,
    required this.yearPlan,
    required this.threeDayPlan,
  });
}
