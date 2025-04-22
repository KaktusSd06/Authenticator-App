import 'package:authenticator_app/core/config/secure_storage_keys.dart';
import 'package:authenticator_app/presentation/screens/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:authenticator_app/presentation/screens/home_screen.dart';
import 'package:authenticator_app/presentation/screens/lock_screen.dart';
import 'package:authenticator_app/presentation/screens/wellcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:secure_application/secure_application.dart';

import 'core/config/theme.dart';
import 'data/services/secure_storage_service.dart';
import 'logic/blocs/locale_cubit.dart';
import 'logic/blocs/tokens/tokens_bloc.dart';

class AppStateService {
  static final AppStateService _instance = AppStateService._internal();
  factory AppStateService() => _instance;
  AppStateService._internal();

  bool isLocked = false;
  bool isAuthenticated = false;
  bool isBiometricDialogOpen = false;

  void setAuthenticated() {
    isAuthenticated = true;
    isLocked = false;
    isBiometricDialogOpen = false;
  }

  void setLocked() {
    isLocked = true;
    isAuthenticated = false;
  }

  void reset() {
    isLocked = false;
    isAuthenticated = false;
    isBiometricDialogOpen = false;
  }

  void setBiometricDialogOpen(bool isOpen) {
    isBiometricDialogOpen = isOpen;
  }

  Future<bool> hasPinCode() async {
    final storage = FlutterSecureStorage();
    final pin = await storage.read(key: SecureStorageKeys.app_pin);
    return pin != null;
  }

  Future<bool> hasBiometricEnabled() async {
    final storage = FlutterSecureStorage();
    final biometricEnabled = await storage.read(key: SecureStorageKeys.biometric_enabled);
    return biometricEnabled == 'true';
  }

  Future<bool> hasAnyAuthMethod() async {
    final hasPin = await hasPinCode();
    final hasBiometric = await hasBiometricEnabled();
    return hasPin || hasBiometric;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );

  const MethodChannel('org.flutter/screen_security')
      .invokeMethod<void>('setSecure', true)
      .catchError((error) => print('Failed to set secure flag: $error'));

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocaleCubit()),
        BlocProvider(create: (_) => TokensBloc()),
        BlocProvider(create: (_) => OnboardingBloc(SecureStorageService.instance)),
      ],
      child: SecureApplication(nativeRemoveDelay: 300, child: MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final AppStateService _appState = AppStateService();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  DateTime? _lastPausedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final bool wasBriefPause =
          (_lastPausedTime != null || _lastPausedTime == null) &&
          DateTime.now().difference(_lastPausedTime!).inSeconds < 3;

      if (!wasBriefPause) {
        final hasAuthMethod = await _appState.hasAnyAuthMethod();
        if (hasAuthMethod) {
          _appState.setLocked();
          _navigatorKey.currentState?.pushReplacement(
            MaterialPageRoute(
              builder:
                  (_) => LockScreen(
                    onAuthStarted: () {
                      _appState.setBiometricDialogOpen(true);
                    },
                    onAuthFinished: () {
                      _appState.setBiometricDialogOpen(false);
                    },
                    onAuthenticated: () {
                      _appState.setAuthenticated();
                      _navigatorKey.currentState?.pushReplacement(
                        MaterialPageRoute(builder: (_) => HomeScreen()),
                      );
                    },
                  ),
            ),
          );
        }
      }
      _lastPausedTime = null;
    } else if (state == AppLifecycleState.paused) {
      _lastPausedTime = DateTime.now();

      if (!_appState.isBiometricDialogOpen) {
        _appState.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp(
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: InitialScreenDecider(),
        );
      },
    );
  }
}

class InitialScreenDecider extends StatefulWidget {
  @override
  State<InitialScreenDecider> createState() => _InitialScreenDeciderState();
}

class _InitialScreenDeciderState extends State<InitialScreenDecider> {
  bool _isLoading = true;
  late bool _hasAuthMethod;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final appState = AppStateService();
    _hasAuthMethod = await appState.hasAnyAuthMethod();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_hasAuthMethod) {
      return LockScreen(
        onAuthStarted: () {
          AppStateService().setBiometricDialogOpen(true);
        },
        onAuthFinished: () {
          AppStateService().setBiometricDialogOpen(false);
        },
        onAuthenticated: () {
          AppStateService().setAuthenticated();
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
        },
      );
    } else {
      return WellcomeScreen();
    }
  }
}
