import 'package:chess/chess/widgets/chess_tile.dart';
import 'package:flutter/material.dart';

class ChessService {

  bool isValidMove(ChessTile movingFrom, ChessTile movingTo) {
          
      if (movingFrom.piece!.character == "P") {
        if (!isValidPawnMove(movingFrom, movingTo, movingFrom.piece!.color == Colors.white)) {
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

bool isValidPawnMove(ChessTile movingFrom, ChessTile movingTo, bool isWhiteTurn) {
  int direction = isWhiteTurn ? 1 : -1; 
    
    // pawn capture
    if (movingTo.row - movingFrom.row == direction && 
        (movingTo.col + 1 == movingFrom.col || movingTo.col - 1 == movingFrom.col)){
      
      return movingTo.piece != null;
    }

    // can only move forward
    if (movingTo.col != movingFrom.col || movingTo.row - movingFrom.row != direction && !movingFrom.piece!.canMoveTwoSquares) {
      return false;
    }

    // tile is occupied
    if (movingTo.piece != null) {
      return false;
    }

    // out of range in column
    if ((movingFrom.row - movingTo.row).abs() > 2) {
      return false;
    } 

    //TODO: stop pawn from jumping over pieces when doing 2 moves

    // can move twice on first turn
    if (!movingFrom.piece!.canMoveTwoSquares &&
        ( movingFrom.row - movingTo.row).abs() >= 2) {
      return false;
    }
    
    movingFrom.piece!.canMoveTwoSquares = false;
    return true;
  }
}