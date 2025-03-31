import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(_getInitialLocale());

  static Locale _getInitialLocale() {
    String systemLanguageCode = WidgetsBinding.instance!.window.locale.languageCode;

    if (systemLanguageCode == 'uk') {
      return const Locale('uk');
    } else {
      return const Locale('en');
    }
  }

  void changeLocale(String languageCode) {
    emit(Locale(languageCode));
  }
}
