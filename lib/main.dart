import 'package:authenticator_app/presentation/screens/home_screen.dart';
import 'package:authenticator_app/presentation/screens/lock_screen.dart';
import 'package:authenticator_app/presentation/screens/wellcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:secure_application/secure_application.dart';
import 'package:flutter/services.dart';

import 'core/config/theme.dart';
import 'logic/blocs/locale_cubit.dart';
import 'logic/blocs/tokens/tokens_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppStateService {
  static final AppStateService _instance = AppStateService._internal();
  factory AppStateService() => _instance;
  AppStateService._internal();

  bool isLocked = false;
  bool isAuthenticated = false;

  void setAuthenticated() {
    isAuthenticated = true;
    isLocked = false;
  }

  void setLocked() {
    isLocked = true;
    isAuthenticated = false;
  }

  void reset() {
    isLocked = false;
    isAuthenticated = false;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.top,
    SystemUiOverlay.bottom,
  ]);

  const MethodChannel('org.flutter/screen_security')
      .invokeMethod<void>('setSecure', true)
      .catchError((error) => print('Failed to set secure flag: $error'));

  runApp(
    SecureApplication(
      nativeRemoveDelay: 300,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => LocaleCubit()),
          BlocProvider(create: (_) => TokensBloc()),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late Future<Widget> _initialScreen;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final AppStateService _appState = AppStateService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialScreen = _getInitialScreen();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final storage = FlutterSecureStorage();
      final isPin = await storage.read(key: 'app_pin');

      if (isPin != null && !_appState.isAuthenticated) {
        _appState.setLocked();

        if (_navigatorKey.currentState != null) {
          _navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(builder: (_) => LockScreenWrapper()),
          );
        }
      }
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _appState.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initialScreen,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.system,
            home: const Center(child: CircularProgressIndicator()),
          );
        }

        return BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return Directionality(
              textDirection: TextDirection.ltr,
              child: SecureGate(
                blurr: 100.0,
                opacity: 0.5,
                lockedBuilder: (context, secureNotifier) {
                  return const Center(child: CircularProgressIndicator());
                },
                child: MaterialApp(
                  navigatorKey: _navigatorKey,
                  debugShowCheckedModeBanner: false,
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  themeMode: ThemeMode.system,
                  locale: locale,
                  supportedLocales: AppLocalizations.supportedLocales,
                  localizationsDelegates: AppLocalizations.localizationsDelegates,
                  home: snapshot.data!,
                ),
              ),
            );
          },
        );

      },
    );
  }

  Future<Widget> _getInitialScreen() async {
    return WellcomeScreen();
  }
}

class LockScreenWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SecureApplicationProvider.of(context)?.secure();

    return LockScreen(
      onAuthenticated: () {
        AppStateService().setAuthenticated();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      },
    );
  }
}