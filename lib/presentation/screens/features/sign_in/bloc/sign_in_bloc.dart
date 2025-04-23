import 'dart:io';
import 'package:authenticator_app/core/config/secure_storage_keys.dart';
import 'package:authenticator_app/data/repositories/remote/synchronize_repository.dart';
import 'package:authenticator_app/presentation/screens/features/sign_in/bloc/sign_in_event.dart';
import 'package:authenticator_app/presentation/screens/features/sign_in/bloc/sign_in_state.dart';
import 'package:authenticator_app/services/auth_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../data/models/auth_token.dart';
import '../../../../../data/repositories/remote/subscription_repository.dart';
import '../../../../../data/repositories/remote/token_repository.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthService _authService = AuthService();
  final SubscriptionRepository _subscriptionRepository = SubscriptionRepository();
  final TokenService _tokenService = TokenService();
  final SynchronizeRepository _synchronizeRepository = SynchronizeRepository();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  SignInBloc() : super(SignInInitial()) {
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<ShowTermError>(_onShowTermError);
    on<ClearTermError>(_onClearTermError);
  }

  Future<File> _getUserInfoFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/user_info.json');
  }

  Future<void> _onSignInWithGoogle(SignInWithGoogle event, Emitter<SignInState> emit) async {
    emit(SignInLoading());
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      emit(const SignInFailure(errorMessage: 'No internet connection'));
      return;
    }

    UserCredential? userCredential = await _authService.signInWithGoogle();

    if (userCredential != null) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final info = await _subscriptionRepository.loadSubscriptionForUser(user.uid);

        if (info != null) {
          var plan = info['plan'];
          var nextBilling = info['nextBilling'];
          var hasFreeTrial = info['hasFreeTrial'];

          await _storage.write(key: SecureStorageKeys.hasFreeTrial, value: hasFreeTrial.toString());
          await _storage.write(key: SecureStorageKeys.subscription, value: plan);
          await _storage.write(key: SecureStorageKeys.nextbilling, value: nextBilling);
        }

        try {
          if (await _synchronizeRepository.isSynchronizing(user.uid)) {
            final tokens = await _tokenService.loadTokensForUser(user.uid);
            final jsonString = AuthToken.listToJson(tokens);
            final file = await _getUserInfoFile();
            await file.writeAsString(jsonString);
          }
        } catch (e) {
        }
      }

      emit(SignInSuccess());
    } else {
      emit(const SignInFailure(errorMessage: 'Error during Google Sign In'));
    }
  }

  void _onShowTermError(ShowTermError event, Emitter<SignInState> emit) {
    emit(SignInTermError());
  }

  void _onClearTermError(ClearTermError event, Emitter<SignInState> emit) {
    emit(SignInInitial());
  }
}