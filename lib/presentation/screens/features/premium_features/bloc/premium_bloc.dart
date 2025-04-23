import 'dart:io';
import 'package:authenticator_app/core/config/secure_storage_keys.dart';
import 'package:authenticator_app/presentation/screens/features/premium_features/bloc/premium_event.dart';
import 'package:authenticator_app/presentation/screens/features/premium_features/bloc/premium_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../data/models/auth_token.dart';
import '../../../../../data/repositories/remote/synchronize_repository.dart';
import '../../../../../data/repositories/remote/token_repository.dart';
import '../../onboarding/onboarding_screen.dart';
import '../../tokens/tokens/tokens_bloc.dart';
import '../../tokens/tokens/tokens_event.dart';
import 'package:authenticator_app/core/config/theme.dart'as app_colors;


class PremiumFeaturesBloc extends Bloc<PremiumFeaturesEvent, PremiumFeaturesState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final SynchronizeRepository _synchronizeRepository = SynchronizeRepository();
  final TokenService _tokenService = TokenService();

  PremiumFeaturesBloc() : super(PremiumFeaturesInitial()) {
    on<LoadPremiumFeatures>(_onLoadPremiumFeatures);
    on<ToggleSync>(_onToggleSync);
    on<SignOut>(_onSignOut);
    on<DeleteAccount>(_onDeleteAccount);
  }

  Future<void> _onLoadPremiumFeatures(LoadPremiumFeatures event, Emitter<PremiumFeaturesState> emit) async {
    emit(PremiumFeaturesLoading());
    try {
      final idToken = await _storage.read(key: SecureStorageKeys.idToken);
      final isSynchronize = await _storage.read(key: SecureStorageKeys.usSync);
      final subscription = await _storage.read(key: SecureStorageKeys.subscription);

      emit(PremiumFeaturesLoaded(
        isAuthenticated: idToken != null,
        isSyncEnabled: isSynchronize == 'true',
        isPremium: subscription != null,
      ));
    } catch (e) {
      emit(PremiumFeaturesError(e.toString()));
    }
  }

  Future<void> _onToggleSync(ToggleSync event, Emitter<PremiumFeaturesState> emit) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    emit(state.copyWith(isSyncing: true));

    try {
      if (event.value) {
        await _storage.write(key: SecureStorageKeys.usSync, value: 'true');
        await _synchronizeRepository.startSynchronize(user.uid);

        final file = await _getUserInfoFile();
        List<AuthToken> tokens = [];
        if (await file.exists()) {
          final content = await file.readAsString();
          if (content.isNotEmpty) {
            tokens = AuthToken.listFromJson(content);
          }
        }

        final idToken = await _storage.read(key: SecureStorageKeys.idToken);
        if (idToken != null && await _synchronizeRepository.isSynchronizing(user.uid)) {
          await _tokenService.saveTokensForUser(user.uid, tokens);
        }
      } else {
        await _storage.delete(key: SecureStorageKeys.usSync);
        await _synchronizeRepository.cancelSynchronize(user.uid);
      }
      emit(state.copyWith(isSyncEnabled: event.value, isSyncing: false));
    } catch (e) {
      emit(PremiumFeaturesError(e.toString()));
      emit(state.copyWith(isSyncing: false));
    }
  }

  Future<File> _getUserInfoFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/user_info.json');
  }

  Future<void> _onSignOut(SignOut event, Emitter<PremiumFeaturesState> emit) async {
    final shouldSignOut = await showDialog<bool>(
      context: event.context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(dialogContext).cardColor,
        title: Text(AppLocalizations.of(dialogContext)!.sign_out, style: Theme.of(dialogContext).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700)),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(AppLocalizations.of(dialogContext)!.cancel, style: const TextStyle(color: app_colors.blue)),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(AppLocalizations.of(dialogContext)!.sign_out, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldSignOut == true) {
      await _storage.delete(key: SecureStorageKeys.idToken);
      await _storage.delete(key: SecureStorageKeys.accessToken);
      await _storage.delete(key: SecureStorageKeys.subscription);
      await _storage.delete(key: SecureStorageKeys.nextbilling);

      final isSynchronize = await _storage.read(key: SecureStorageKeys.usSync);
      if (isSynchronize == "true") {
        BlocProvider.of<TokensBloc>(event.context).add(DeleteAllTokens());
      }
      emit(state.copyWith(isAuthenticated: false, isPremium: false));
    }
  }

  Future<void> _onDeleteAccount(DeleteAccount event, Emitter<PremiumFeaturesState> emit) async {
    await _storage.deleteAll();
    emit(state.copyWith(isAuthenticated: false, isPremium: false));
    Navigator.of(event.context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
          (Route<dynamic> route) => false,
    );
  }
}