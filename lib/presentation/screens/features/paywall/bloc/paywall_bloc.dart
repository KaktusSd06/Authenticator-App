import 'package:authenticator_app/presentation/screens/features/paywall/bloc/paywall_event.dart';
import 'package:authenticator_app/presentation/screens/features/paywall/bloc/paywall_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import '../../../../../core/config/secure_storage_keys.dart';
import '../../../../../data/repositories/remote/subscription_repository.dart';
import '../../../../../data/services/secure_storage_service.dart';
import '../paywall_plan.dart';

class PaywallBloc extends Bloc<PaywallEvent, PaywallState> {
  final FlutterSecureStorage storage = SecureStorageService.instance;

  PaywallBloc() : super(PaywallState.initial()) {
    on<SelectPlanEvent>(_onSelectPlan);
    on<ToggleTrialEvent>(_onToggleTrial);
  }

  void _onSelectPlan(SelectPlanEvent event, Emitter<PaywallState> emit) {
    if (event.plan != state.selectedPlan) {
      if (event.plan == PaywallPlan.weekly) {
        emit(state.copyWith(
            selectedPlan: PaywallPlan.weekly,
            isTrialEnabled: true,
            isContinueButtonEnabled: true
        ));
      } else if (event.plan == PaywallPlan.yearly) {
        emit(state.copyWith(
            selectedPlan: PaywallPlan.yearly,
            isTrialEnabled: false,
            isContinueButtonEnabled: true
        ));
      }

      _processPlanSelection();
    }
  }

  void _onToggleTrial(ToggleTrialEvent event, Emitter<PaywallState> emit) {
    if (event.value) {
      emit(state.copyWith(
          isTrialEnabled: true,
          selectedPlan: PaywallPlan.weekly,
          isContinueButtonEnabled: true
      ));
    } else {
      emit(state.copyWith(
          isTrialEnabled: false,
          selectedPlan: PaywallPlan.yearly,
          isContinueButtonEnabled: true
      ));
    }

    _processPlanSelection();
  }

  Future<void> _processPlanSelection() async {
    String plan = state.selectedPlan == PaywallPlan.weekly
        ? "week"
        : state.selectedPlan == PaywallPlan.yearly
        ? "year"
        : "none";

    if (plan == "none") return;

    DateTime nextBillingDate;
    if (state.selectedPlan == PaywallPlan.weekly) {
      nextBillingDate = DateTime.now().add(Duration(days: 7));
    } else if (state.selectedPlan == PaywallPlan.yearly) {
      nextBillingDate = DateTime.now().add(Duration(days: 365));
    } else {
      return;
    }

    String formattedDate = DateFormat('dd.MM.yyyy').format(nextBillingDate);
    await storage.write(key: SecureStorageKeys.subscription, value: plan);
    await storage.write(key: SecureStorageKeys.nextbilling, value: formattedDate);
    await storage.write(
        key: SecureStorageKeys.hasFreeTrial,
        value: state.isTrialEnabled.toString()
    );

    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userEmail = user.email ?? '';
      SubscriptionRepository().saveSubscriptionForUser(
        uid: user.uid,
        email: userEmail,
        plan: plan,
        nextBilling: formattedDate,
        hasFreeTrial: state.isTrialEnabled,
      );
    }
  }
}