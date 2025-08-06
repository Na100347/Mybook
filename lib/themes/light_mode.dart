import 'package:flutter/material.dart';

final ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Color(0xFF212121), // Màu chữ chính (đen nhạt)
    secondary: Color(0xFFFF9800), // Màu cam cho đường gạch và chip
    tertiary: Color(0xFF7E57C2), // Màu tím đậm cho một số icon
    background: Color(0xFFEDE7F6), // Màu nền tím nhạt (đầu gradient)
    surface: Color(0xFFFFFFFF), // Nền trắng cho CircleAvatar và Card
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF212121), fontSize: 16),
    bodyMedium: TextStyle(color: Color(0xFF212121), fontSize: 14),
    headlineSmall: TextStyle(color: Color(0xFF212121), fontSize: 18, fontWeight: FontWeight.bold),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.purple,
    elevation: 0,
    titleTextStyle: TextStyle(color: Color(0xFF212121), fontSize: 16, fontWeight: FontWeight.bold),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Color(0xFFFF9800),
    unselectedItemColor: Color(0xFF757575),
    backgroundColor: Colors.white,
    selectedLabelStyle: TextStyle(fontSize: 12),
    unselectedLabelStyle: TextStyle(fontSize: 12),
  ),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF7E57C2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF212121)),
    ),
    filled: true,
    fillColor: Color(0xFFFFFFFF),
    hintStyle: TextStyle(color: Color(0xFF757575)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFFF9800),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
);