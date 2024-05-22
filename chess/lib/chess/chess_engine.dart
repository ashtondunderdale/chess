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
        
      // case PieceType.rook:
      //   return isValidRookMove(piece, destinationRow, destinationColumn, boardState);

      case PieceType.knight:
        return isValidKnightMove(piece, destinationRow, destinationColumn, boardState);

      // case PieceType.bishop:
      //   return isValidBishopMove(piece, destinationRow, destinationColumn, boardState);

      // case PieceType.queen:
      //   return isValidQueenMove(piece, destinationRow, destinationColumn, boardState);

      // case PieceType.king:
      //   return isValidKingMove(piece, destinationRow, destinationColumn, boardState);

      default:
        return false;
    }
  }

  bool isValidPawnMove(ChessPiece piece, int destinationRow, int destinationColumn, List<List<ChessPiece?>> boardState) {
    return getValidPawnMoves(piece, boardState).any((move) => move[0] == destinationRow && move[1] == destinationColumn);
  }
  
  bool isValidKnightMove(ChessPiece piece, int destinationRow, int destinationColumn, List<List<ChessPiece?>> boardState) {
    return getValidKnightMove(piece, boardState).any((move) => move[0] == destinationRow && move[1] == destinationColumn);
  }

  List<List<int>> getValidPawnMoves(ChessPiece piece, List<List<ChessPiece?>> boardState) {
    final currentRow = piece.row;
    final currentColumn = piece.column;
    final color = piece.color;

    List<List<int>> validMoves = [];

    if (color == Colors.white) {
      for (var row = 0; row < 8; row++) {
        for (var column = 0; column < 8; column++) { 
          if (column != currentColumn) {
            continue;
          }

          if (row > currentRow || row < currentRow - 1 && currentRow != 6) {
            continue;
          }

          if (row > currentRow || row < currentRow - 2) {
            continue;
          }          
          
          if (column > 0 && row == currentRow - 1 && boardState[row][column - 1] != null && boardState[row][column - 1]!.color != color) {
            validMoves.add([row, column - 1]);
          }
          if (column < 7 && row == currentRow - 1 && boardState[row][column + 1] != null && boardState[row][column + 1]!.color != color) {
            validMoves.add([row, column + 1]);
          }

          if (boardState[currentRow - 1][currentColumn] != null) {
            continue;
          }

          if (boardState[row][column] != null) {
            continue;
          }

          validMoves.add([row, column]);
        }
      }
    } else {
      for (var row = 0; row < 8; row++) {
        for (var column = 0; column < 8; column++) {
          if (column != currentColumn) {
            continue;
          }

          if (row < currentRow || row > currentRow + 1 && currentRow != 1) {
            continue;
          }

          if (row < currentRow || row > currentRow + 2) {
            continue;
          }        
          
          if (column > 0 && row == currentRow + 1 && boardState[row][column - 1] != null && boardState[row][column - 1]!.color != color) {
            validMoves.add([row, column - 1]);
          }
          if (column < 7 && row == currentRow + 1 && boardState[row][column + 1] != null && boardState[row][column + 1]!.color != color) {
            validMoves.add([row, column + 1]);
          }

          if (boardState[currentRow + 1][currentColumn] != null) {
            continue;
          }

          if (boardState[row][column] != null) {
            continue;
          }

          validMoves.add([row, column]);
        }
      }
    }

    return validMoves;
  }

  List<List<int>> getValidKnightMove(ChessPiece piece, List<List<ChessPiece?>> boardState) {
    final currentRow = piece.row;
    final currentColumn = piece.column;
    final color = piece.color;

    List<List<int>> validMoves = [];

      validMoves.add([currentRow - 1, currentColumn - 2]);
      validMoves.add([currentRow - 2, currentColumn - 1]);
      validMoves.add([currentRow - 2, currentColumn + 1]);
      validMoves.add([currentRow - 1, currentColumn + 2]);

      validMoves.add([currentRow + 1, currentColumn + 2]);
      validMoves.add([currentRow + 2, currentColumn + 1]);
      validMoves.add([currentRow + 2, currentColumn - 1]);
      validMoves.add([currentRow + 1, currentColumn - 2]);

      for (var row = 0; row < 8; row++) {
        for (var column = 0; column < 8; column++) {        
          if (boardState[row][column]?.color == Colors.white && validMoves.any((move) => move[0] == row && move[1] == column)) {
            validMoves.removeWhere((move) => move[0] == row && move[1] == column);
          }
        }
      }

      return validMoves;
  }
}