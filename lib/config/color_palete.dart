import 'package:flutter/material.dart';

abstract class ColorPalete {
  static const primaryColor = 0xFF3F8DFD;
  static const backgroundColor = 0xFF1B1A1D;
  static const textColor = 0xFFCCCECE;
  static const onBackgroundColor = 0xFF2B2D2E;
  static const onPrimaryColor = 0xFFF8F9F9;

  static final ThemeData themeData =
      ThemeData(colorScheme: colorScheme, appBarTheme: appBarTheme);

  // Configuracion de paleta de colores
  static const ColorScheme colorScheme = ColorScheme(
    primary: Color(primaryColor),
    secondary: Color(primaryColor),
    surface: Color(primaryColor),
    background: Color(backgroundColor),
    error: Color(0xFFD32F2F),
    onPrimary: Color(onPrimaryColor),
    onSecondary: Color(onPrimaryColor),
    onSurface: Color(onPrimaryColor),
    onBackground: Color(onBackgroundColor),
    onError: Color(0xFFFFFFFF),
    brightness: Brightness.dark,
  );

  // Configuracion de la barra superior
  static const AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: Color(backgroundColor),
    elevation: 0,
    iconTheme: IconThemeData(
      color: Color(textColor),
    ),
  );
}
