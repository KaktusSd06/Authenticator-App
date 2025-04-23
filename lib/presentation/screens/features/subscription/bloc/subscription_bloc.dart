import 'package:authenticator_app/core/config/secure_storage_keys.dart';
import 'package:authenticator_app/data/repositories/remote/subscription_repository.dart';
import 'package:authenticator_app/presentation/screens/features/subscription/bloc/subscription_event.dart';
import 'package:authenticator_app/presentation/screens/features/subscription/bloc/subscription_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' as intl;

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository _subscriptionRepository = SubscriptionRepository();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  SubscriptionBloc() : super(SubscriptionInitial()) {
    on<LoadSubscription>(_onLoadSubscription);
    on<ClearSubscriptionData>(_onClearSubscriptionData);
    on<RestorePurchases>(_onRestorePurchases);
  }

  Future<void> _onLoadSubscription(LoadSubscription event, Emitter<SubscriptionState> emit) async {
    emit(SubscriptionLoading());
    try {
      final isPremium = await _isPremium();
      final isAuthenticated = await _isAuthenticated();
      String subscriptionType = 'none';
      String billingDate = 'none';

      if (isPremium) {
        subscriptionType = await _getSubscriptionType();
        billingDate = await _getBillingDate();
      }

      emit(SubscriptionLoaded(
        isPremium: isPremium,
        isAuthenticated: isAuthenticated,
        subscriptionType: subscriptionType,
        billingDate: billingDate,
      ));
    } catch (e) {
      emit(SubscriptionError(errorMessage: e.toString()));
    }
  }

  Future<void> _onClearSubscriptionData(ClearSubscriptionData event, Emitter<SubscriptionState> emit) async {
    await _storage.delete(key: SecureStorageKeys.subscription);
    await _storage.delete(key: SecureStorageKeys.nextbilling);
    await _storage.delete(key: SecureStorageKeys.hasFreeTrial);

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _subscriptionRepository.cancelSubscription(user.uid ?? '');
    }
    add(LoadSubscription());
  }

  Future<void> _onRestorePurchases(RestorePurchases event, Emitter<SubscriptionState> emit) async {
    add(LoadSubscription());
  }

  Future<bool> _isAuthenticated() async {
    final idToken = await _storage.read(key: SecureStorageKeys.idToken);
    return idToken != null;
  }

  Future<bool> _isPremium() async {
    final subscription = await _storage.read(key: SecureStorageKeys.subscription);
    return subscription != null;
  }

  Future<String> _getSubscriptionType() async {
    final subscription = await _storage.read(key: SecureStorageKeys.subscription);
    if (subscription != null) {
      if (subscription == "trial") {
        return "trial";
      } else if (subscription == "year") {
        return "year";
      } else if (subscription == "week") {
        return "week";
      }
    }
    return "none";
  }

  Future<String> _getBillingDate() async {
    final billing = await _storage.read(key: SecureStorageKeys.nextbilling);
    if (billing != null) {
      try {
        DateTime date = DateFormat("dd.MM.yyyy").parse(billing);
        String locale = intl.Intl.getCurrentLocale();
        String formattedDate = DateFormat("MMMM dd, yyyy", locale).format(date);
        return formattedDate;
      } catch (e) {
        print("Error parsing billing date: $e");
        return "none";
      }
    }
    return "none";
  }
}