import 'package:flutter/material.dart';

// Custom color palette
const Color white = Color(0xFFFFFFFF);
const Color gray1 = Color(0xFFF9F9F9);
const Color gray2 = Color(0xFFE1E1E1);
const Color gray3 = Color(0xFFC7C7C7);
const Color gray4 = Color(0xFFACACAC);
const Color gray5 = Color(0xFF8C8C8C);
const Color gray6 = Color(0xFF5F5F5F);
const Color mainBlue = Color(0xFF1B539A);
const Color blue = Color(0xFF5B88C0);
const Color lightBlue = Color(0xFFC6DFFF);

// Light Theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: mainBlue,
  hintColor: gray6,
  scaffoldBackgroundColor: gray1,
  cardColor: gray2,
  fontFamily: 'Inter',

  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
    displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
    displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    headlineLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    headlineMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    headlineSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: mainBlue,
    textTheme: ButtonTextTheme.primary,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: mainBlue,
    elevation: 0,
  ),
  // Use the custom grays for input fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: gray3,
  ),
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: mainBlue,
  hintColor: gray1,
  scaffoldBackgroundColor: gray6,
  cardColor: gray5,
  fontFamily: 'Inter',
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
    displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
    displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    headlineLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    headlineMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    headlineSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: mainBlue,
    textTheme: ButtonTextTheme.primary,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: mainBlue,
    elevation: 0,
  ),
  // Use darker grays for input fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: gray4,
  ),
);
