import 'package:flutter/material.dart';

Color boardBorderColor = Colors.black;
Color selectedPieceColor = const Color.fromARGB(255, 255, 249, 199);
Color selectedPieceValidMoveColor = const Color.fromARGB(255, 230, 230, 230);

Color monochromeLightSquareColor = const Color.fromARGB(255, 185, 185, 185);
Color monochromeDarkSquareColor = const Color.fromARGB(255, 87, 87, 87);

Color classicLightSquareColor = const Color.fromARGB(255, 216, 188, 178);
Color classicDarkSquareColor = const Color.fromARGB(255, 90, 69, 46);

Color defaultLightSquareColor = const Color.fromARGB(255, 221, 226, 207);
Color defaultDarkSquareColor = Color.fromARGB(255, 90, 141, 71);


class BoardTheme {
  late Color lightSquareColor;
  late Color darkSquareColor;

  String theme;
  String squareTheme = "default";
  List<String> availableThemes = ["default", "classic", "monochrome"];
  int currentThemeIndex = 0;

  BoardTheme({required this.theme}) : 
    lightSquareColor = defaultLightSquareColor,
    darkSquareColor = defaultDarkSquareColor;

  void updateTheme() {
    currentThemeIndex = (currentThemeIndex + 1) % availableThemes.length;
    squareTheme = availableThemes[currentThemeIndex];

    switch (squareTheme) {
      case "default":
        lightSquareColor = defaultLightSquareColor;
        darkSquareColor = defaultDarkSquareColor;
        break;

      case "classic":
        lightSquareColor = classicLightSquareColor;
        darkSquareColor = classicDarkSquareColor;
        break;

      case "monochrome":
        lightSquareColor = monochromeLightSquareColor;
        darkSquareColor = monochromeDarkSquareColor;
        break;

      default:
        lightSquareColor = defaultLightSquareColor;
        darkSquareColor = defaultDarkSquareColor;
    }
  }
}
