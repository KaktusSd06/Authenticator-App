import 'package:authenticator_app/presentation/screens/features/onboarding/bloc/onboarding_event.dart';
import 'package:authenticator_app/presentation/screens/features/onboarding/bloc/onboarding_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../core/config/secure_storage_keys.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState>{
  final FlutterSecureStorage storage;

  static const int totalPages = 4;

  OnboardingBloc(this.storage) : super(OnboardingState.initial(isFirstAppLaunch: false)){
    on<OnboardingStarted>((event, emit) async{
      await storage.write(key: SecureStorageKeys.isFirst, value: 'false');
    });

    on<OnboardingPageChanged>((event, emit) async{
      double progress = event.page / (totalPages - 1);
      emit(state.copyWith(currentPage: event.page, progress: progress));
    });

    on<OnboardingNextPressed>((event, emit) {
      final nextPage = state.currentPage + 1;

      if (nextPage >= totalPages) {
        emit(state.copyWith(navigateToPaywall: true));
      } else {
        final progress = nextPage / (totalPages - 1);
        emit(state.copyWith(
          currentPage: nextPage,
          progress: progress,
        ));
      }
    });
  }
}