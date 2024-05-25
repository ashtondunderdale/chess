import 'dart:math';

import 'package:chess/chess/chess_engine.dart';
import 'package:flutter/material.dart';
import 'chess_piece.dart';

class ComputerEngine {
  final _engine = ChessEngine();

  ChessPiece? generateRandomMove(List<List<ChessPiece?>> boardState, bool isWhiteMove, Color? colorInCheck) {
    var rand = Random();
    var colorToMove = isWhiteMove ? Colors.white : Colors.black; 

    var rowIndex = 0;
    var squareIndex = 0;
    ChessPiece piece;

    if (_engine.getStalemateColor(boardState, isWhiteMove) != null) {
      return null;
    }

    if (_engine.getCheckmateColor(boardState, isWhiteMove) != null) {
      return null;
    }

    try {
      while (true) {
        rowIndex = rand.nextInt(8);
        squareIndex = rand.nextInt(8);

        if (boardState[rowIndex][squareIndex] == null) {
          continue;
        }

        piece = boardState[rowIndex][squareIndex]!;

        if (piece.color != colorToMove) {
          continue;
        }

        piece = boardState[rowIndex][squareIndex]!;

        var validPieceMoves = _engine.getValidPawnMoves(piece, boardState);
        
        switch (piece.type) {
          case PieceType.pawn:
            validPieceMoves = _engine.getValidPawnMoves(piece, boardState);
            
          case PieceType.rook:
            validPieceMoves = _engine.getValidRookMoves(piece, boardState);

          case PieceType.knight:
            validPieceMoves = _engine.getValidKnightMoves(piece, boardState);

          case PieceType.bishop:
            validPieceMoves = _engine.getValidBishopMoves(piece, boardState);

          case PieceType.queen:
            validPieceMoves = _engine.getValidQueenMoves(piece, boardState);

          case PieceType.king:
            validPieceMoves = _engine.getValidKingMoves(piece, boardState);

          default:
            validPieceMoves = [];
        }

        if (validPieceMoves.isNotEmpty) {
          var moveIndex = rand.nextInt(validPieceMoves.length);
          var move = validPieceMoves[moveIndex];

          var row = move[0];
          var column = move[1];

          if (!_engine.isValidMove(piece, row, column, boardState, colorInCheck)) {
            continue;
          }

          ChessPiece? capturedPieceOrNull = _engine.makeMove(piece, row, column, boardState);
          return capturedPieceOrNull;
        }
      }
    } catch (e) {
      print(e);
    }
    return null; 
  }
}