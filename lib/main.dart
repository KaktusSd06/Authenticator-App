import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logic/blocs/theme_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Authenticator App',
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.blue,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.blue,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            themeMode: themeMode,
            home: const AuthenticatorHomePage(),
          );
        },
      ),
    );
  }
}

class AuthenticatorHomePage extends StatelessWidget {
  const AuthenticatorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authenticator App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.light_mode),
            onPressed: () {
              context.read<ThemeBloc>().add(ThemeEvent.light);
            },
          ),
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              context.read<ThemeBloc>().add(ThemeEvent.dark);
            },
          ),
        ],
      ),
      body: const Center(child: Text("Authenticator App")),
    );
  }
}
