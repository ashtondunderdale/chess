import 'package:flutter/material.dart';

import 'chess_piece.dart';

class ChessEngine {
  Color? engineColorInCheck;

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

  bool isValidMove(ChessPiece piece, int destinationRow, int destinationColumn, List<List<ChessPiece?>> boardState, Color? colorInCheck) {
    engineColorInCheck = colorInCheck;
    
    var originalRow = piece.row;
    var originalColumn = piece.column;
    var capturedPiece = boardState[destinationRow][destinationColumn];
    
    boardState[originalRow][originalColumn] = null;
    boardState[destinationRow][destinationColumn] = piece;
    piece.row = destinationRow;
    piece.column = destinationColumn;
    
    bool isStillInCheck = getColorInCheck(boardState) == piece.color;
    
    piece.row = originalRow;
    piece.column = originalColumn;
    boardState[originalRow][originalColumn] = piece;
    boardState[destinationRow][destinationColumn] = capturedPiece;
    
    return !isStillInCheck && isValidMoveWithoutCheck(piece, destinationRow, destinationColumn, boardState);
  }
  
  bool isValidMoveWithoutCheck(ChessPiece piece, int destinationRow, int destinationColumn, List<List<ChessPiece?>> boardState) {
    switch (piece.type) {
      case PieceType.pawn:
        return isValidPawnMove(piece, destinationRow, destinationColumn, boardState);
        
      case PieceType.rook:
        return isValidRookMove(piece, destinationRow, destinationColumn, boardState);

      case PieceType.knight:
        return isValidKnightMove(piece, destinationRow, destinationColumn, boardState);

      case PieceType.bishop:
        return isValidBishopMove(piece, destinationRow, destinationColumn, boardState);

      case PieceType.queen:
        return isValidQueenMove(piece, destinationRow, destinationColumn, boardState);

      case PieceType.king:
        return isValidKingMove(piece, destinationRow, destinationColumn, boardState);

      default:
        return false;
    }
  }

  Color? testCheckmate(List<List<ChessPiece?>> boardState, bool isWhiteMove) {
    Color color = isWhiteMove ? Colors.white : Colors.black;

    if (getColorInCheck(boardState) != color) {
      return null;
    }

    for (var i = 0; i < 8; i++) {
      for (var j = 0; j < 8; j++) {
        var piece = boardState[i][j];

        if (piece != null && piece.color == color) {
          List<List<int>> validMoves = [];

          switch (piece.type) {
            case PieceType.pawn:
              validMoves = getValidPawnMoves(piece, boardState);
              break;
            case PieceType.rook:
              validMoves = getValidRookMoves(piece, boardState);
              break;
            case PieceType.knight:
              validMoves = getValidKnightMoves(piece, boardState);
              break;
            case PieceType.bishop:
              validMoves = getValidBishopMoves(piece, boardState);
              break;
            case PieceType.queen:
              validMoves = getValidQueenMoves(piece, boardState);
              break;
            case PieceType.king:
              validMoves = getValidKingMoves(piece, boardState);
              break;
          }

          for (var move in validMoves) {
            var copiedBoardState = simulateMove(boardState, piece, move[0], move[1]);
            if (getColorInCheck(copiedBoardState) != color) {
              return null;
            }
          }
        }
      }
    }

    return color == Colors.white ? Colors.black : Colors.white;
  }

  List<List<ChessPiece?>> simulateMove(List<List<ChessPiece?>> boardState, ChessPiece piece, int row, int column) {
    var copiedBoardState = List<List<ChessPiece?>>.generate(8, (i) => List<ChessPiece?>.from(boardState[i]));

    copiedBoardState[piece.row][piece.column] = null;
    copiedBoardState[row][column] = ChessPiece(
      type: piece.type,
      color: piece.color,
      row: row,
      column: column,
    );

    return copiedBoardState;
  }

  bool isValidPawnMove(ChessPiece piece, int destinationRow, int destinationColumn, List<List<ChessPiece?>> boardState) {
    return getValidPawnMoves(piece, boardState).any((move) => move[0] == destinationRow && move[1] == destinationColumn);
  }
  
  bool isValidKnightMove(ChessPiece piece, int destinationRow, int destinationColumn, List<List<ChessPiece?>> boardState) {
    return getValidKnightMoves(piece, boardState).any((move) => move[0] == destinationRow && move[1] == destinationColumn);
  }

  bool isValidBishopMove(ChessPiece piece, int destinationRow, int destinationColumn, List<List<ChessPiece?>> boardState) {
    return getValidBishopMoves(piece, boardState).any((move) => move[0] == destinationRow && move[1] == destinationColumn);
  }

  bool isValidRookMove(ChessPiece piece, int destinationRow, int destinationColumn, List<List<ChessPiece?>> boardState) {
    return getValidRookMoves(piece, boardState).any((move) => move[0] == destinationRow && move[1] == destinationColumn);
  }

  bool isValidQueenMove(ChessPiece piece, int destinationRow, int destinationColumn, List<List<ChessPiece?>> boardState) {
    return getValidQueenMoves(piece, boardState).any((move) => move[0] == destinationRow && move[1] == destinationColumn);
  }

  bool isValidKingMove(ChessPiece piece, int destinationRow, int destinationColumn, List<List<ChessPiece?>> boardState) {
    return getValidKingMoves(piece, boardState).any((move) => move[0] == destinationRow && move[1] == destinationColumn);
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

  List<List<int>> getValidKnightMoves(ChessPiece piece, List<List<ChessPiece?>> boardState) {
    final currentRow = piece.row;
    final currentColumn = piece.column;
    final color = piece.color;

    List<List<int>> validMoves = [];

    List<List<int>> knightOffsets = [
      [-1, -2], [-2, 1], [-1, 2], [1, 2],
      [-2, -1], [1, -2], [2, -1], [2, 1], 
    ];

    for (var offset in knightOffsets) {
      int row = currentRow + offset[0];
      int column = currentColumn + offset[1];

      if (row >= 0 && row < 8 && column >= 0 && column < 8) {
        if (boardState[row][column] == null || boardState[row][column]!.color != color) {
          validMoves.add([row, column]);
        }
      }
    }

      return validMoves;
  }

  List<List<int>> getValidBishopMoves(ChessPiece piece, List<List<ChessPiece?>> boardState) {
    final currentRow = piece.row;
    final currentColumn = piece.column;
    final color = piece.color;

    List<List<int>> validMoves = [];

    List<List<int>> directions = [
      [-1, -1], [-1, 1], [1, -1], [1, 1]
    ];

    for (var direction in directions) {
      int dx = direction[0];
      int dy = direction[1];

      for (int i = 1; i < 8; i++) {
        int row = currentRow + i * dx;
        int column = currentColumn + i * dy;

        if (row < 0 || row >= 8 || column < 0 || column >= 8) {
          continue;
        }

        if (boardState[row][column] == null || boardState[row][column]!.color != color) {
          validMoves.add([row, column]);
        }
        
        if (boardState[row][column] != null) {
          break;
        }
      }
    }
  
    return validMoves;
  }
  
  List<List<int>> getValidRookMoves(ChessPiece piece, List<List<ChessPiece?>> boardState) {
    final currentRow = piece.row;
    final currentColumn = piece.column;
    final color = piece.color;

    List<List<int>> validMoves = [];

    var directions = [
      [1, 0], [-1, 0], [0, 1], [0, -1]
    ];

    for (var direction in directions) {
      int dx = direction[0];
      int dy = direction[1];

      for (var i = 1; i < 8; i++) {
        var row = currentRow + i * dx;
        var column = currentColumn + i * dy;

        if (row < 0 || row >= 8 || column < 0 || column >= 8) {
          continue;
        }

        if (boardState[row][column] == null || boardState[row][column]!.color != color) {
          validMoves.add([row, column]);
        }
        
        if (boardState[row][column] != null) {
          break;
        }
      }
    }
    
    return validMoves;
  }

  List<List<int>> getValidQueenMoves(ChessPiece piece, List<List<ChessPiece?>> boardState) {
    List<List<int>> validMoves = [];

    // LOL
    validMoves += getValidBishopMoves(piece, boardState);
    validMoves += getValidRookMoves(piece, boardState);
    
    return validMoves;
  }

  List<List<int>> getValidKingMoves(ChessPiece piece, List<List<ChessPiece?>> boardState) {
    final currentRow = piece.row;
    final currentColumn = piece.column;
    
    List<List<int>> validMoves = [];

    for (int row = currentRow - 1; row <= currentRow + 1; row++) {
      for (int column = currentColumn - 1; column <= currentColumn + 1; column++) {
        if (row == currentRow && column == currentColumn) {
          continue;
        }

        if (row < 0 || row >= 8 || column < 0 || column >= 8) {
          continue;
        }

        if (boardState[row][column] != null) {
          if (boardState[row][column]!.color == piece.color) {
          continue;
          }
        }
        
        validMoves.add([row, column]);
      }
    }
    
    return validMoves;
  }

  Color? getColorInCheck(List<List<ChessPiece?>> boardState) {
    int? whiteKingRow;
    int? whiteKingColumn;
    int? blackKingRow;
    int? blackKingColumn;

    for (var i = 0; i < 8; i++) {
      for (var j = 0; j < 8; j++) {
        if (boardState[i][j]?.type == PieceType.king) {
          if (boardState[i][j]?.color == Colors.white) {
            whiteKingRow = i;
            whiteKingColumn = j;
          } else if (boardState[i][j]?.color == Colors.black) {
            blackKingRow = i;
            blackKingColumn = j;
          }
        }
      }
    }

    bool isKingInCheck(int kingRow, int kingColumn, Color color) {
      for (var i = 0; i < 8; i++) {
        for (var j = 0; j < 8; j++) {
          var piece = boardState[i][j];

          if (piece == null || piece.color == color) {
            continue;
          }

          List<List<int>> validMoves = [];

          switch (piece.type) {
            case PieceType.pawn:
              validMoves = getValidPawnMoves(piece, boardState);
              break;
            case PieceType.knight:
              validMoves = getValidKnightMoves(piece, boardState);
              break;
            case PieceType.bishop:
              validMoves = getValidBishopMoves(piece, boardState);
              break;
            case PieceType.rook:
              validMoves = getValidRookMoves(piece, boardState);
              break;
            case PieceType.queen:
              validMoves = getValidQueenMoves(piece, boardState);
              break;
            case PieceType.king:
              validMoves = getValidKingMoves(piece, boardState);
              break;
          }

          for (var move in validMoves) {
            if (move[0] == kingRow && move[1] == kingColumn) {
              return true;
            }
          }
        }
      }
      return false;
    }

    if (whiteKingRow != null && whiteKingColumn != null && isKingInCheck(whiteKingRow, whiteKingColumn, Colors.white)) {
      return Colors.white;
    }

    if (blackKingRow != null && blackKingColumn != null && isKingInCheck(blackKingRow, blackKingColumn, Colors.black)) {
      return Colors.black;
    }

    return null;
  }
}