import 'dart:math';

import 'package:chess/chess/chess_engine.dart';
import 'package:flutter/material.dart';

import 'chess_piece.dart';

class ComputerEngine {
  final _engine = ChessEngine();

  void generateRandomValidChessMove(List<List<ChessPiece?>> boardState) {
    var rand = Random();

    var rowIndex = 0;
    var squareIndex = 0;
    var validPieceMoves = [];
    ChessPiece piece;

    while (true) {
      rowIndex = rand.nextInt(8);
      squareIndex = rand.nextInt(8);

      if (boardState[rowIndex][squareIndex] == null) {
        continue;
      }

      piece = boardState[rowIndex][squareIndex]!;

      while (validPieceMoves.isEmpty) {
        validPieceMoves = _engine.getValidPawnMoves(piece, boardState);
      }

      break;
    }

    var moveIndex = rand.nextInt(validPieceMoves.length);
    var move = validPieceMoves[moveIndex];

    var row = move[0];
    var column = move[1];

    _engine.makeMove(piece, row, column, boardState);
  }
}