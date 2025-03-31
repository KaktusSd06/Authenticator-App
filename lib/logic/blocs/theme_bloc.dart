import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

// Стан теми
enum ThemeEvent { light, dark }

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.system);

  @override
  Stream<ThemeMode> mapEventToState(ThemeEvent event) async* {
    switch (event) {
      case ThemeEvent.light:
        yield ThemeMode.light;
        break;
      case ThemeEvent.dark:
        yield ThemeMode.dark;
        break;
    }
  }
}
