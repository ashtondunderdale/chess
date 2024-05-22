import 'package:flutter/material.dart';

import 'chess_piece.dart';

class ChessEngine {

  bool isCorrectPlayerTurn(bool isWhiteMove, ChessPiece movedPiece) {
    if (isWhiteMove && movedPiece.color != Colors.white) {
      return false;
    } else if (!isWhiteMove && movedPiece.color != Colors.black) {
      return false;
    }

    return true;
  }

  ChessPiece? makeMove(ChessPiece movedPiece, int row, int column, List<List<ChessPiece?>> boardState) {
    boardState[movedPiece.row][movedPiece.column] = null;
    
    movedPiece.row = row;
    movedPiece.column = column;

    var capturedPiece = boardState[row][column];
    boardState[row][column] = movedPiece;

    return capturedPiece;
  }
  
  bool isValidMove(ChessPiece piece, int destinationRow, int destinationColumn, List<List<ChessPiece?>> boardState) {
    switch (piece.type) {
      case PieceType.pawn:
        return isValidPawnMove(piece, destinationRow, destinationColumn, boardState);

      default:
        return false;
        
      // case PieceType.rook:
      //   return isValidRookMove(piece, destinationRow, destinationColumn, boardState);

      // case PieceType.knight:
      //   return isValidKnightMove(piece, destinationRow, destinationColumn, boardState);

      // case PieceType.bishop:
      //   return isValidBishopMove(piece, destinationRow, destinationColumn, boardState);

      // case PieceType.queen:
      //   return isValidQueenMove(piece, destinationRow, destinationColumn, boardState);

      // case PieceType.king:
      //   return isValidKingMove(piece, destinationRow, destinationColumn, boardState);
    }
  }

  bool isValidPawnMove(ChessPiece piece, int destinationRow, int destinationColumn, List<List<ChessPiece?>> boardState) {
    return getValidPawnMoves(piece, boardState).any((move) => move[0] == destinationRow && move[1] == destinationColumn);
  }

  List<List<int>> getValidPawnMoves(ChessPiece piece, List<List<ChessPiece?>> boardState) {
    final currentRow = piece.row;
    final currentColumn = piece.column;
    final color = piece.color;

    List<List<int>> validMoves = [];

    for (var row = 0; row < 8; row++) {
      for (var column = 0; column < 8; column++) {
        //var square = boardState[row][column];

        if (column == currentColumn ) {
          validMoves.add([row, column]);
        }
      }
    }

    return validMoves;
  }
}