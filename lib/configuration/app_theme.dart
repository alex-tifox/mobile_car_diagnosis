import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get applicationTheme => ThemeData(
        colorScheme: ColorScheme(
            primary: Color(0xFF807CB0),
            primaryVariant: Color(0xFF4C3C8A),
            secondary: Color(0xFFACB07C),
            secondaryVariant: Color(0xFF6B7535),
            surface: Color(0xFFC7C5DE),
            background: Color(0xFFE8E8F1),
            error: Color(0xFF9E220C),
            onPrimary: Color(0xFF191919),
            onSecondary: Color(0xFF191919),
            onSurface: Color(0xFF191919),
            onBackground: Color(0xFF191919),
            onError: Color(0xFFF9F9F9),
            brightness: Brightness.light),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Color(0xFFF9F9F9),
            fontFamily: 'Nunito',
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
          ),
          subtitle1: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          button: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
          ),
          bodyText2: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      );
}
