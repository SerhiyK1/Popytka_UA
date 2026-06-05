import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFF1E2228);
  static const Color surface = Color(
    0xFF2C313A,
  ); // Slightly lighter for non-glass
  static const Color primary = Color(0xFFFFD600); // Yellow
  static const Color secondary = Color(0xFF29B6F6); // Blue
  static const Color textMain = Colors.white;
  static const Color textSecondary = Colors.white70;

  static const Color glassFill = Color(0x66000000); // More transparent
  static const Color glassBorder = Color(0x33FFFFFF); // Brighter border
  static const Color glassAccent = Color(0x1AFFFFFF); // Subtle white tint
  static const Color cardSurface = surface;
}
