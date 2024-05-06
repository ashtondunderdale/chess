import 'package:flutter/material.dart';

class ChessPiece {
  Color color;
  String name;
  String character;

  // only for pawn
  bool canMoveTwoSquares = true;

  ChessPiece({
    required this.color, 
    required this.character, 
    required this.name
  });
}