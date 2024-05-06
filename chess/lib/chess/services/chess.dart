import 'dart:math';

import 'package:chess/chess/widgets/chess_tile.dart';

class ChessService {

  bool isValidMove(ChessTile movingFrom, ChessTile movingTo) {
          
      if (movingFrom.piece!.character == "P") {
        if (!isValidPawnMove(movingFrom, movingTo)) {
          return false;
        }
      }

      // empty square
      if (movingTo.piece == null) {
        return true;
      }

      // same color
      if (movingFrom.piece!.color == movingTo.piece!.color) {
        return false;
      }

      return true;
  }

  bool isValidPawnMove(ChessTile movingFrom, ChessTile movingTo) {

    // pawn capture
    if (movingTo.row + 1 == movingFrom.row && 
        (movingTo.col + 1 == movingFrom.col || movingTo.col - 1 == movingFrom.col)){
      
      if (movingTo.piece == null) {
        return false;
      } 

      return true;
    }
    
    // can only move up
    if (movingTo.col != movingFrom.col) {
      return false;
    }

    // can move twice on first turn
    if (movingFrom.row - movingTo.row > 2) {
      return false;
    } 

    if (!movingFrom.piece!.canMoveTwoSquares &&
        movingFrom.row - movingTo.row >= 2) {
      return false;
    }

    movingFrom.piece!.canMoveTwoSquares = false;
    return true;
  }
}