import 'package:flutter/material.dart';

Color boardBorderColor = Colors.black;
Color selectedPieceColor = const Color.fromARGB(255, 255, 249, 199);
Color selectedPieceValidMoveColor = const Color.fromARGB(255, 230, 230, 230);

class BoardTheme {
  late Color lightSquareColor;
  late Color darkSquareColor;

  late String squareTheme;
  late int currentThemeIndex;
  late List<String> themeKeys;

  late Map<String, Map<String, Color>> availableThemes = {
    "default": {
      "light": const Color.fromARGB(255, 221, 226, 207),
      "dark": const Color.fromARGB(255, 90, 141, 71),
    },
    "classic": {
      "light": const Color.fromARGB(255, 228, 210, 204),
      "dark": const Color.fromARGB(255, 170, 149, 127),
    },
    "monochrome": {
      "light": const Color.fromARGB(255, 185, 185, 185),
      "dark": const Color.fromARGB(255, 87, 87, 87),
    },
  };

  BoardTheme({
    required String squareTheme,
  }) {
    themeKeys = availableThemes.keys.toList();
    currentThemeIndex = themeKeys.indexOf(squareTheme);
    updateTheme();
  }

  void updateTheme() {
    currentThemeIndex = (currentThemeIndex + 1) % themeKeys.length;
    
    final currentThemeKey = themeKeys[currentThemeIndex];
    final themeColors = availableThemes[currentThemeKey]!;

    lightSquareColor = themeColors['light'] ?? Colors.white;
    darkSquareColor = themeColors['dark'] ?? Colors.black;
  }
}