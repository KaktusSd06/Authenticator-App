import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../../core/config/secure_storage_keys.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();

  AuthBloc() : super(AuthInitial()) {
    on<VerifyPinEvent>(_verifyPin);
    on<SetNewPinEvent>(_setNewPin);
    on<ChangePinEvent>(_changePin);
    on<CheckBiometricAvailabilityEvent>(_checkBiometricAvailability);
    on<ToggleBiometricEvent>(_toggleBiometric);
    on<AuthenticateWithBiometricsEvent>(_authenticateWithBiometrics);
    on<DeletePinEvent>(_deletePin);
    on<CheckPinExistsEvent>(_checkPinExists);
  }

  Future<void> _verifyPin(VerifyPinEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      String? storedPin = await _secureStorage.read(key: SecureStorageKeys.app_pin);

      if (storedPin == null) {
        await _secureStorage.write(key: SecureStorageKeys.app_pin, value: event.pin);
        emit(PinVerificationSuccess());
      } else if (event.pin == storedPin) {
        emit(PinVerificationSuccess());
      } else {
        emit(PinVerificationFailed('Incorrect PIN'));
      }
    } catch (e) {
      emit(PinVerificationFailed('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> _setNewPin(SetNewPinEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _secureStorage.write(key: SecureStorageKeys.app_pin, value: event.pin);
      emit(NewPinCreated());
    } catch (e) {
      emit(PinVerificationFailed('Failed to create PIN: ${e.toString()}'));
    }
  }

  Future<void> _changePin(ChangePinEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      String? storedPin = await _secureStorage.read(key: SecureStorageKeys.app_pin);

      if (storedPin == event.oldPin) {
        await _secureStorage.write(key: SecureStorageKeys.app_pin, value: event.newPin);
        emit(PinChangeSuccess());
      } else {
        emit(PinChangeFailed('Incorrect old PIN'));
      }
    } catch (e) {
      emit(PinChangeFailed('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> _checkBiometricAvailability(
      CheckBiometricAvailabilityEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      List<BiometricType> availableBiometrics = [];

      if (canCheckBiometrics) {
        availableBiometrics = await _localAuth.getAvailableBiometrics();
      }

      String? biometricEnabled = await _secureStorage.read(key: SecureStorageKeys.biometric_enabled);
      bool isAvailable = availableBiometrics.isNotEmpty;
      bool isEnabled = biometricEnabled == 'true';

      emit(BiometricState(isAvailable: isAvailable, isEnabled: isEnabled));
    } catch (e) {
      emit(BiometricAuthFailed('Failed to check biometrics: ${e.toString()}'));
    }
  }

  Future<void> _toggleBiometric(ToggleBiometricEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      if (event.enabled) {
        await _secureStorage.write(key: SecureStorageKeys.biometric_enabled, value: 'true');
      } else {
        await _secureStorage.delete(key: SecureStorageKeys.biometric_enabled);
      }

      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      List<BiometricType> availableBiometrics = [];

      if (canCheckBiometrics) {
        availableBiometrics = await _localAuth.getAvailableBiometrics();
      }

      emit(BiometricState(
          isAvailable: availableBiometrics.isNotEmpty,
          isEnabled: event.enabled
      ));
    } catch (e) {
      emit(BiometricAuthFailed('Failed to toggle biometrics: ${e.toString()}'));
    }
  }

  Future<void> _authenticateWithBiometrics(
      AuthenticateWithBiometricsEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      String? biometricEnabled = await _secureStorage.read(key: SecureStorageKeys.biometric_enabled);
      if (biometricEnabled != 'true') {
        emit(BiometricAuthFailed('Biometric authentication is not enabled'));
        return;
      }

      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        emit(BiometricAuthFailed('Biometric authentication is not available'));
        return;
      }

      List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        emit(BiometricAuthFailed('No biometric features available'));
        return;
      }

      String biometricPrompt = 'Authenticate to access the app';

      bool authenticated = await _localAuth.authenticate(
        localizedReason: biometricPrompt,
        options: const AuthenticationOptions(stickyAuth: true, biometricOnly: false),
      );

      if (authenticated) {
        emit(BiometricAuthSuccess());
      } else {
        emit(BiometricAuthFailed('Authentication failed'));
      }
    } catch (e) {
      if (e.toString().contains('canceled') || e.toString().contains('cancelled')) {
        emit(AuthInitial());
      } else {
        emit(BiometricAuthFailed('Biometric authentication error: ${e.toString()}'));
      }
    }
  }

  Future<void> _deletePin(DeletePinEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _secureStorage.delete(key: SecureStorageKeys.app_pin);
      emit(PinRemoved());
    } catch (e) {
      emit(PinVerificationFailed('Failed to delete PIN: ${e.toString()}'));
    }
  }

  Future<void> _checkPinExists(CheckPinExistsEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      String? storedPin = await _secureStorage.read(key: SecureStorageKeys.app_pin);
      emit(PinExistsState(storedPin != null));
    } catch (e) {
      emit(PinVerificationFailed('Failed to check PIN: ${e.toString()}'));
    }
  }
}

