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

  /// `Лише 0.83 на тиждень`
  String get paywell_info {
    return Intl.message(
      'Лише 0.83 на тиждень',
      name: 'paywell_info',
      desc: '',
      args: [],
    );
  }

  /// `Пробний період`
  String get free_Trial_Enabled {
    return Intl.message(
      'Пробний період',
      name: 'free_Trial_Enabled',
      desc: '',
      args: [],
    );
  }

  /// `1 Рік`
  String get year {
    return Intl.message('1 Рік', name: 'year', desc: '', args: []);
  }

  /// `39,99 USD Лише 0.83 на тиждень`
  String get uSD_Only {
    return Intl.message(
      '39,99 USD Лише 0.83 на тиждень',
      name: 'uSD_Only',
      desc: '',
      args: [],
    );
  }

  /// `3 Дні пробного періодну`
  String get free_day {
    return Intl.message(
      '3 Дні пробного періодну',
      name: 'free_day',
      desc: '',
      args: [],
    );
  }

  /// `далі 6.99 usd на тиждень`
  String get than_6 {
    return Intl.message(
      'далі 6.99 usd на тиждень',
      name: 'than_6',
      desc: '',
      args: [],
    );
  }

  /// `Оберіть свій план\nта відчуйте переваги`
  String get paywell_H1 {
    return Intl.message(
      'Оберіть свій план\nта відчуйте переваги',
      name: 'paywell_H1',
      desc: '',
      args: [],
    );
  }

  /// `Subtitle text about benefits`
  String get paywell_T1 {
    return Intl.message(
      'Subtitle text about benefits',
      name: 'paywell_T1',
      desc: '',
      args: [],
    );
  }

  /// `Вхід`
  String get signin {
    return Intl.message('Вхід', name: 'signin', desc: '', args: []);
  }

  /// `Вітаємо в\nAuthenticator`
  String get wellcome {
    return Intl.message(
      'Вітаємо в\nAuthenticator',
      name: 'wellcome',
      desc: '',
      args: [],
    );
  }

  /// `Увійти з`
  String get sign_in_with {
    return Intl.message('Увійти з', name: 'sign_in_with', desc: '', args: []);
  }

  /// `Я приймаю`
  String get terms_of_app {
    return Intl.message('Я приймаю', name: 'terms_of_app', desc: '', args: []);
  }

  /// `Умови використання`
  String get terms_of_service {
    return Intl.message(
      'Умови використання',
      name: 'terms_of_service',
      desc: '',
      args: [],
    );
  }

  /// `Політику конфіденційності`
  String get privacy_policy {
    return Intl.message(
      'Політику конфіденційності',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `та`
  String get and {
    return Intl.message('та', name: 'and', desc: '', args: []);
  }

  /// `Ви маєте погодитись з  Умовами використання та Політикою конфеденційності щоб продовжити вхід`
  String get term_error {
    return Intl.message(
      'Ви маєте погодитись з  Умовами використання та Політикою конфеденційності щоб продовжити вхід',
      name: 'term_error',
      desc: '',
      args: [],
    );
  }

  /// `Sign In Error`
  String get error_with_signIn {
    return Intl.message(
      'Sign In Error',
      name: 'error_with_signIn',
      desc: '',
      args: [],
    );
  }

  /// `Error logging in, please try again later`
  String get error_signIn_message {
    return Intl.message(
      'Error logging in, please try again later',
      name: 'error_signIn_message',
      desc: '',
      args: [],
    );
  }

  /// `Пошук`
  String get search {
    return Intl.message('Пошук', name: 'search', desc: '', args: []);
  }

  /// `Підтримка клієнтів`
  String get customer_support {
    return Intl.message(
      'Підтримка клієнтів',
      name: 'customer_support',
      desc: '',
      args: [],
    );
  }

  /// `Зв'язатись з нами`
  String get contact_us {
    return Intl.message(
      'Зв\'язатись з нами',
      name: 'contact_us',
      desc: '',
      args: [],
    );
  }

  /// `Умови використання`
  String get terms_of_use {
    return Intl.message(
      'Умови використання',
      name: 'terms_of_use',
      desc: '',
      args: [],
    );
  }

  /// `Корисна інформація`
  String get usefull_info {
    return Intl.message(
      'Корисна інформація',
      name: 'usefull_info',
      desc: '',
      args: [],
    );
  }

  /// `Про програму Authenticator`
  String get about_app {
    return Intl.message(
      'Про програму Authenticator',
      name: 'about_app',
      desc: '',
      args: [],
    );
  }

  /// `Підписка`
  String get subscription {
    return Intl.message('Підписка', name: 'subscription', desc: '', args: []);
  }

  /// `Преміум переваги`
  String get premium_features {
    return Intl.message(
      'Преміум переваги',
      name: 'premium_features',
      desc: '',
      args: [],
    );
  }

  /// `це програма, яка генерує безпечні коди двофакторної автентифікації (2FA) для ваших облікових записів. Коли ви налаштовуєте свій обліковий запис із двофакторною автентифікацією (2FA), ви отримаєте секретний ключ, який потрібно ввести в Authenticator, зазвичай ключ у формі QR-коду.`
  String get about_p1 {
    return Intl.message(
      'це програма, яка генерує безпечні коди двофакторної автентифікації (2FA) для ваших облікових записів. Коли ви налаштовуєте свій обліковий запис із двофакторною автентифікацією (2FA), ви отримаєте секретний ключ, який потрібно ввести в Authenticator, зазвичай ключ у формі QR-коду.',
      name: 'about_p1',
      desc: '',
      args: [],
    );
  }

  /// `Це встановлює безпечне з’єднання між`
  String get about_p2 {
    return Intl.message(
      'Це встановлює безпечне з’єднання між',
      name: 'about_p2',
      desc: '',
      args: [],
    );
  }

  /// `та вашим акаунтом.`
  String get about_p3 {
    return Intl.message(
      'та вашим акаунтом.',
      name: 'about_p3',
      desc: '',
      args: [],
    );
  }

  /// `Після встановлення безпечного з’єднання Authenticator згенерує 6-8-значний код, необхідний для доступу до вашого облікового запису.\n\nНавіть якщо хтось знає ваш пароль, йому все одно потрібен код 2FA для доступу до вашого облікового запису.`
  String get about_p4 {
    return Intl.message(
      'Після встановлення безпечного з’єднання Authenticator згенерує 6-8-значний код, необхідний для доступу до вашого облікового запису.\n\nНавіть якщо хтось знає ваш пароль, йому все одно потрібен код 2FA для доступу до вашого облікового запису.',
      name: 'about_p4',
      desc: '',
      args: [],
    );
  }

  /// `Ваша активна підписка`
  String get current_plan {
    return Intl.message(
      'Ваша активна підписка',
      name: 'current_plan',
      desc: '',
      args: [],
    );
  }

  /// `Наступна дата оплати`
  String get billing_date {
    return Intl.message(
      'Наступна дата оплати',
      name: 'billing_date',
      desc: '',
      args: [],
    );
  }

  /// `Змінити план`
  String get change_plan {
    return Intl.message(
      'Змінити план',
      name: 'change_plan',
      desc: '',
      args: [],
    );
  }

  /// `Відновити підписку`
  String get restore_purchases {
    return Intl.message(
      'Відновити підписку',
      name: 'restore_purchases',
      desc: '',
      args: [],
    );
  }

  /// `Обрати план`
  String get choose_a_plan {
    return Intl.message(
      'Обрати план',
      name: 'choose_a_plan',
      desc: '',
      args: [],
    );
  }

  /// `Пробна підписка`
  String get free_trial {
    return Intl.message(
      'Пробна підписка',
      name: 'free_trial',
      desc: '',
      args: [],
    );
  }

  /// `Річна підписка`
  String get year_subscription {
    return Intl.message(
      'Річна підписка',
      name: 'year_subscription',
      desc: '',
      args: [],
    );
  }

  /// `Місячна підписка`
  String get weekly_subscription {
    return Intl.message(
      'Місячна підписка',
      name: 'weekly_subscription',
      desc: '',
      args: [],
    );
  }

  /// `Вийти з акаунту`
  String get sign_out {
    return Intl.message(
      'Вийти з акаунту',
      name: 'sign_out',
      desc: '',
      args: [],
    );
  }

  /// `Синхронізувати`
  String get synchronize {
    return Intl.message(
      'Синхронізувати',
      name: 'synchronize',
      desc: '',
      args: [],
    );
  }

  /// `Видалити профіль`
  String get delete_account {
    return Intl.message(
      'Видалити профіль',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Цю дію не можна відмінити`
  String get delete_account_confirm {
    return Intl.message(
      'Цю дію не можна відмінити',
      name: 'delete_account_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Скасувати`
  String get cancel {
    return Intl.message('Скасувати', name: 'cancel', desc: '', args: []);
  }

  /// `Видалити`
  String get delete {
    return Intl.message('Видалити', name: 'delete', desc: '', args: []);
  }

  /// `На основі часу`
  String get time_based {
    return Intl.message(
      'На основі часу',
      name: 'time_based',
      desc: '',
      args: [],
    );
  }

  /// `Одноразові`
  String get counter_based {
    return Intl.message(
      'Одноразові',
      name: 'counter_based',
      desc: '',
      args: [],
    );
  }

  /// `Загальне`
  String get general {
    return Intl.message('Загальне', name: 'general', desc: '', args: []);
  }

  /// `Сервіси`
  String get services {
    return Intl.message('Сервіси', name: 'services', desc: '', args: []);
  }

  /// `Сервіс`
  String get service {
    return Intl.message('Сервіс', name: 'service', desc: '', args: []);
  }

  /// `Профіль`
  String get account {
    return Intl.message('Профіль', name: 'account', desc: '', args: []);
  }

  /// `Ключ`
  String get key {
    return Intl.message('Ключ', name: 'key', desc: '', args: []);
  }

  /// `Додати`
  String get add {
    return Intl.message('Додати', name: 'add', desc: '', args: []);
  }

  /// `Оновити`
  String get update {
    return Intl.message('Оновити', name: 'update', desc: '', args: []);
  }

  /// `Сканувати QR-код`
  String get scan_qr {
    return Intl.message(
      'Сканувати QR-код',
      name: 'scan_qr',
      desc: '',
      args: [],
    );
  }

  /// `Додати код самостійно`
  String get enter_code {
    return Intl.message(
      'Додати код самостійно',
      name: 'enter_code',
      desc: '',
      args: [],
    );
  }

  /// `Додати профіль`
  String get add_account {
    return Intl.message(
      'Додати профіль',
      name: 'add_account',
      desc: '',
      args: [],
    );
  }

  /// `Додати 2FA коди`
  String get add_2fa {
    return Intl.message('Додати 2FA коди', name: 'add_2fa', desc: '', args: []);
  }

  /// `Захистіть свої облікові записи, додавши двофакторну автентифікацію.`
  String get keep_account {
    return Intl.message(
      'Захистіть свої облікові записи, додавши двофакторну автентифікацію.',
      name: 'keep_account',
      desc: '',
      args: [],
    );
  }

  /// `Оновити код`
  String get update_code {
    return Intl.message('Оновити код', name: 'update_code', desc: '', args: []);
  }

  /// `Ви впевнені, що бажаєте оновити код?`
  String get sure_update {
    return Intl.message(
      'Ви впевнені, що бажаєте оновити код?',
      name: 'sure_update',
      desc: '',
      args: [],
    );
  }

  /// `Помилка додавання`
  String get add_error {
    return Intl.message(
      'Помилка додавання',
      name: 'add_error',
      desc: '',
      args: [],
    );
  }

  /// `Помилка додавання елемента, спробуйте пізніше`
  String get add_error_message {
    return Intl.message(
      'Помилка додавання елемента, спробуйте пізніше',
      name: 'add_error_message',
      desc: '',
      args: [],
    );
  }

  /// `Редагувати`
  String get edit {
    return Intl.message('Редагувати', name: 'edit', desc: '', args: []);
  }

  /// `Підтвердження`
  String get confirming {
    return Intl.message(
      'Підтвердження',
      name: 'confirming',
      desc: '',
      args: [],
    );
  }

  /// `Видалити обраний елемент?`
  String get delete_conf {
    return Intl.message(
      'Видалити обраний елемент?',
      name: 'delete_conf',
      desc: '',
      args: [],
    );
  }

  /// `Так`
  String get yes {
    return Intl.message('Так', name: 'yes', desc: '', args: []);
  }

  /// `Ні`
  String get no {
    return Intl.message('Ні', name: 'no', desc: '', args: []);
  }

  /// `Помилка редагування`
  String get edit_error {
    return Intl.message(
      'Помилка редагування',
      name: 'edit_error',
      desc: '',
      args: [],
    );
  }

  /// `Помилка під час редагування елемента`
  String get edit_error_message {
    return Intl.message(
      'Помилка під час редагування елемента',
      name: 'edit_error_message',
      desc: '',
      args: [],
    );
  }

  /// `Зберегти`
  String get save {
    return Intl.message('Зберегти', name: 'save', desc: '', args: []);
  }

  /// `Редагувати профіль`
  String get edit_account {
    return Intl.message(
      'Редагувати профіль',
      name: 'edit_account',
      desc: '',
      args: [],
    );
  }

  /// `Заповніть всі поля`
  String get fill_all_fields {
    return Intl.message(
      'Заповніть всі поля',
      name: 'fill_all_fields',
      desc: '',
      args: [],
    );
  }

  /// `Неправильний ключ`
  String get invalid_key {
    return Intl.message(
      'Неправильний ключ',
      name: 'invalid_key',
      desc: '',
      args: [],
    );
  }

  /// `Лише великі літери від A да Z та числа 2–7`
  String get invalid_key_description {
    return Intl.message(
      'Лише великі літери від A да Z та числа 2–7',
      name: 'invalid_key_description',
      desc: '',
      args: [],
    );
  }

  /// `Помилка з'єднання`
  String get connection_error {
    return Intl.message(
      'Помилка з\'єднання',
      name: 'connection_error',
      desc: '',
      args: [],
    );
  }

  /// `Відсутнє інтернет з'єднання, спробуйте пізніше`
  String get connection_error_message {
    return Intl.message(
      'Відсутнє інтернет з\'єднання, спробуйте пізніше',
      name: 'connection_error_message',
      desc: '',
      args: [],
    );
  }

  /// `Закрити`
  String get close {
    return Intl.message('Закрити', name: 'close', desc: '', args: []);
  }

  /// `Скасувати підписку`
  String get cancel_plan {
    return Intl.message(
      'Скасувати підписку',
      name: 'cancel_plan',
      desc: '',
      args: [],
    );
  }

  /// `Паролі та безпеки`
  String get password_security {
    return Intl.message(
      'Паролі та безпеки',
      name: 'password_security',
      desc: '',
      args: [],
    );
  }

  /// `Пароль`
  String get password {
    return Intl.message('Пароль', name: 'password', desc: '', args: []);
  }

  /// `Біометрія`
  String get biometrics {
    return Intl.message('Біометрія', name: 'biometrics', desc: '', args: []);
  }

  /// `Змінити пароль`
  String get change_password {
    return Intl.message(
      'Змінити пароль',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Редагувати password`
  String get edit_password {
    return Intl.message(
      'Редагувати password',
      name: 'edit_password',
      desc: '',
      args: [],
    );
  }

  /// `Змінити`
  String get change {
    return Intl.message('Змінити', name: 'change', desc: '', args: []);
  }

  /// `Введіть PIN-код`
  String get enter_pin {
    return Intl.message(
      'Введіть PIN-код',
      name: 'enter_pin',
      desc: '',
      args: [],
    );
  }

  /// `Невірний PIN-код`
  String get incorrect_pin {
    return Intl.message(
      'Невірний PIN-код',
      name: 'incorrect_pin',
      desc: '',
      args: [],
    );
  }

  /// `PIN коди не збігаються`
  String get pins_do_not_match {
    return Intl.message(
      'PIN коди не збігаються',
      name: 'pins_do_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Створіть PIN`
  String get create_pin {
    return Intl.message('Створіть PIN', name: 'create_pin', desc: '', args: []);
  }

  /// `Підтвердіть PIN`
  String get confirm_pin {
    return Intl.message(
      'Підтвердіть PIN',
      name: 'confirm_pin',
      desc: '',
      args: [],
    );
  }

  /// `Введіть поточний PIN`
  String get enter_old_pin {
    return Intl.message(
      'Введіть поточний PIN',
      name: 'enter_old_pin',
      desc: '',
      args: [],
    );
  }

  /// `Введіть новий PIN`
  String get enter_new_pin {
    return Intl.message(
      'Введіть новий PIN',
      name: 'enter_new_pin',
      desc: '',
      args: [],
    );
  }

  /// `Підтвердіть новий PIN`
  String get confirm_new_pin {
    return Intl.message(
      'Підтвердіть новий PIN',
      name: 'confirm_new_pin',
      desc: '',
      args: [],
    );
  }

  /// `Зміна PIN-коду`
  String get change_pin {
    return Intl.message(
      'Зміна PIN-коду',
      name: 'change_pin',
      desc: '',
      args: [],
    );
  }

  /// `Авторизуйтесь для входу в додаток`
  String get authenticate_with_biometrics {
    return Intl.message(
      'Авторизуйтесь для входу в додаток',
      name: 'authenticate_with_biometrics',
      desc: '',
      args: [],
    );
  }

  /// `Помилка біометричної автентифікації`
  String get biometric_error {
    return Intl.message(
      'Помилка біометричної автентифікації',
      name: 'biometric_error',
      desc: '',
      args: [],
    );
  }

  /// `Біометрика недоступна на цьому пристрої`
  String get biometric_not_available {
    return Intl.message(
      'Біометрика недоступна на цьому пристрої',
      name: 'biometric_not_available',
      desc: '',
      args: [],
    );
  }

  /// `Біометричну автентифікацію увімкнено`
  String get biometric_enabled {
    return Intl.message(
      'Біометричну автентифікацію увімкнено',
      name: 'biometric_enabled',
      desc: '',
      args: [],
    );
  }

  /// `Збереже 88%`
  String get save_88 {
    return Intl.message('Збереже 88%', name: 'save_88', desc: '', args: []);
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
