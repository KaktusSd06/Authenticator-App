// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Привіт`
  String get hello {
    return Intl.message('Привіт', name: 'hello', desc: '', args: []);
  }

  /// `Вітаю`
  String get welcome {
    return Intl.message('Вітаю', name: 'welcome', desc: '', args: []);
  }

  /// `Продовжити`
  String get continue_btn {
    return Intl.message('Продовжити', name: 'continue_btn', desc: '', args: []);
  }

  /// `Безпечний\nобліковий запис`
  String get onBoarding_H1 {
    return Intl.message(
      'Безпечний\nобліковий запис',
      name: 'onBoarding_H1',
      desc: '',
      args: [],
    );
  }

  /// `Просте налаштування\n сканування камерою`
  String get onBoarding_H2 {
    return Intl.message(
      'Просте налаштування\n сканування камерою',
      name: 'onBoarding_H2',
      desc: '',
      args: [],
    );
  }

  /// `Покращення\nконфеденційності`
  String get onBoarding_H3 {
    return Intl.message(
      'Покращення\nконфеденційності',
      name: 'onBoarding_H3',
      desc: '',
      args: [],
    );
  }

  /// `Отримати доступ \nдо всіх функцій`
  String get onBoarding_H4 {
    return Intl.message(
      'Отримати доступ \nдо всіх функцій',
      name: 'onBoarding_H4',
      desc: '',
      args: [],
    );
  }

  /// `Надійно захистіть свої данні від\nпроникнення або втрати`
  String get onBoarding_T1 {
    return Intl.message(
      'Надійно захистіть свої данні від\nпроникнення або втрати',
      name: 'onBoarding_T1',
      desc: '',
      args: [],
    );
  }

  /// `Просто зіскануйте QR код\nабо додайте самостійноy`
  String get onBoarding_T2 {
    return Intl.message(
      'Просто зіскануйте QR код\nабо додайте самостійноy',
      name: 'onBoarding_T2',
      desc: '',
      args: [],
    );
  }

  /// `Безпечно проводьте криптовалютні транзакції\nта безпечно додавайте гаманець`
  String get onBoarding_T3 {
    return Intl.message(
      'Безпечно проводьте криптовалютні транзакції\nта безпечно додавайте гаманець',
      name: 'onBoarding_T3',
      desc: '',
      args: [],
    );
  }

  /// `3 БЕЗКОШТОВНИХ дні\nдалі 6.99 USD на тиждень`
  String get onBoarding_T4 {
    return Intl.message(
      '3 БЕЗКОШТОВНИХ дні\nдалі 6.99 USD на тиждень',
      name: 'onBoarding_T4',
      desc: '',
      args: [],
    );
  }

  /// `Повернутись`
  String get restor_l {
    return Intl.message('Повернутись', name: 'restor_l', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'uk')];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
