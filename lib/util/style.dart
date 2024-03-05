import 'package:flutter/material.dart';

class StylePage {
  // Color Palettes
  static const MaterialColor primaryColor = MaterialColor(
    0xFFFCECEC, // Main color
    <int, Color>{
      50: Color(0xFFFCECEC),
      100: Color(0xFFF9E5E5),
      200: Color(0xFFF8D1E6),
    },
  );

  static const Color accentColor = Color(0xFFFFDFDF);
  static const Color backgroundColor = Color(0xFFFFF6F6);
  static const Color iconBackground = Color(0xFFAEDEFC);
  static const Color textColor = Color(0xFF333333);

  // Fonts
  static const TextStyle titleTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle subtitleTextStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    color: textColor,
  );

  static ThemeData get appTheme => ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: primaryColor,
        ).copyWith(
          background: backgroundColor,
        ),
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          displayLarge: titleTextStyle,
        ),
        checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
      );
}
