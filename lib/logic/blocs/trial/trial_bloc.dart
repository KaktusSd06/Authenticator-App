import 'package:flutter_bloc/flutter_bloc.dart';
import 'trial_event.dart';
import 'trial_state.dart';

class TrialBloc extends Bloc<TrialEvent, TrialState> {
  TrialBloc() : super(TrialInitialState(isTrialEnabled: false, yearPlan: false, threeDayPlan: false));

  @override
  Stream<TrialState> mapEventToState(TrialEvent event) async* {
    if (event is ToggleTrialEvent) {
      final currentState = state as TrialInitialState;
      yield TrialStateUpdated(
        isTrialEnabled: !currentState.isTrialEnabled,
        yearPlan: false,
        threeDayPlan: false,
      );
    }
    if (event is SelectYearPlanEvent) {
      final currentState = state as TrialInitialState;
      yield TrialStateUpdated(
        isTrialEnabled: false,
        yearPlan: true,
        threeDayPlan: false,
      );
    }
    if (event is SelectThreeDayPlanEvent) {
      final currentState = state as TrialInitialState;
      yield TrialStateUpdated(
        isTrialEnabled: true,
        yearPlan: false,
        threeDayPlan: true,
      );
    }
  }
}
