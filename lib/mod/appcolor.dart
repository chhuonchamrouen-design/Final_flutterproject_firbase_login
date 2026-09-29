import 'package:flutter/material.dart';

// Constant used by your delete icon (const so it works inside `const Icon(...)`)
const Color discountRed = Color(0xFFE53935);

extension Appcolor on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get appPageBg =>
      isDarkMode ? const Color(0xFF0E0E10) : const Color(0xFFFFFFFF);

  Color get appSurface => Theme.of(this).colorScheme.surface;

  Color get appPanel =>
      isDarkMode ? const Color(0xFF2C2C2E) : const Color(0xFFEDEDED);

  Color get appText => Theme.of(this).colorScheme.onSurface;

  Color get appMuted => appText.withAlpha(140);

  Color get appBorder =>
      isDarkMode ? const Color(0xFF3A3A3C) : const Color(0xFFE6E6E6);

  Color get appStrongBorder =>
      isDarkMode ? const Color(0xFF555558) : Colors.grey;
}