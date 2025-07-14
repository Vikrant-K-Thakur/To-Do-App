import 'package:flutter/material.dart';
import 'color_mode.dart';

ThemeData getTheme(ColorMode mode) {
  switch (mode) {
    case ColorMode.skyBlue:
      return ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF2196F3),
        scaffoldBackgroundColor: Color(0xFFF1F9FF),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1976D2),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1565C0),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF1565C0),
          unselectedItemColor: Colors.black54,
          backgroundColor: Color(0xFFE3F2FD),
        ),
      );

    case ColorMode.sunsetOrange:
      return ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFFFF7043),
        scaffoldBackgroundColor: Color(0xFFFFF3E0),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFF4511E),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFD84315),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFFD84315),
          unselectedItemColor: Colors.black54,
          backgroundColor: Color(0xFFFFF3E0),
        ),
      );

    case ColorMode.amberOrange:
      return ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFFEF6C00),
        scaffoldBackgroundColor: Color(0xFFFFF3E0),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFEF6C00),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFB8C00),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFFFB8C00),
          unselectedItemColor: Colors.grey[700],
          backgroundColor: Color(0xFFFFF3E0),
        ),
      );

    case ColorMode.forestGreen:
      return ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF388E3C),
        scaffoldBackgroundColor: Color(0xFFE8F5E9),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1B5E20),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF1B5E20),
          unselectedItemColor: Colors.black54,
          backgroundColor: Color(0xFFE8F5E9),
        ),
      );

    case ColorMode.arcticWhite: // New theme
      return ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF1976D2),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1976D2),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF1976D2)),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1976D2),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF1976D2),
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.white,
          elevation: 2,
        ),
      );

    case ColorMode.purpleHaze:
      return ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF6A1B9A),
        scaffoldBackgroundColor: Color(0xFFF3E5F5),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF6A1B9A),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF9C27B0),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF9C27B0),
          unselectedItemColor: Colors.grey[700],
          backgroundColor: Color(0xFFF3E5F5),
        ),
      );

    case ColorMode.emeraldGreen:
      return ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF2E7D32),
        scaffoldBackgroundColor: Color(0xFFE8F5E9),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF43A047),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF43A047),
          unselectedItemColor: Colors.grey[700],
          backgroundColor: Color(0xFFE8F5E9),
        ),
      );

    case ColorMode.deepOcean:
      return ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0D47A1),
        scaffoldBackgroundColor: Color(0xFF121212),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0D47A1),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1976D2),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF64B5F6),
          unselectedItemColor: Colors.grey[400],
          backgroundColor: Color(0xFF1E1E1E),
        ),
      );
  }
}
