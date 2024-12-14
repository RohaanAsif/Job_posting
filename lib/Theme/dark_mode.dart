import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    brightness: Brightness.light,
    surface: Colors.grey.shade100,
    primary: Colors.black,
    secondary: Colors.blueGrey.shade200,
    tertiary: Colors.blueGrey.shade700,
    inversePrimary: Colors.white,
  ),
);
