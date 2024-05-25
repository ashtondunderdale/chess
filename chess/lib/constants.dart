import 'package:flutter/material.dart';

Color boardBorderColor = Colors.black;
Color selectedPieceColor = const Color.fromARGB(255, 255, 249, 199);
Color selectedPieceValidMoveColor = const Color.fromARGB(255, 230, 230, 230);

class BoardTheme {
  Color defaultLightSquareColor = const Color.fromARGB(255, 185, 185, 185);
  Color defaultDarkSquareColor = const Color.fromARGB(255, 87, 87, 87);

  String theme;
  BoardThemes boardColor;
  
  BoardTheme({required this.theme, required this.boardColor});
}

enum BoardThemes {
  monochrome
}