import 'package:authenticator_app/presentation/screens/home_screen.dart';
import 'package:authenticator_app/presentation/screens/lock_screen.dart';
import 'package:authenticator_app/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'core/config/theme.dart';
import 'logic/blocs/locale_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:local_auth/local_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    BlocProvider(
      create: (_) => LocaleCubit(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.system,
            home: Center(child: CircularProgressIndicator()),
          );
        }

        return BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: ThemeMode.system,
              locale: locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: snapshot.data!,
            );
          },
        );
      },
    );
  }

  Future<Widget> _getInitialScreen() async {
    final storage = FlutterSecureStorage();
    final isFirst = await storage.read(key: 'isFirst');
    final isPin = await storage.read(key: 'app_pin');
    if (isFirst != null) {
      if (isPin != null){
        return LockScreen();
      }
      else {
        return HomeScreen();
      }
    } else {
      return OnBoardingScreen();
    }
  }
}