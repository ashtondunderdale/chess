import 'package:chess/chess/widgets/chess_tile.dart';

class ChessService {

  bool isValidMove(ChessTile movingFrom, ChessTile movingTo) {
      
      if (movingFrom.piece!.character == "P") {
        return isValidPawnMove(movingFrom, movingTo);
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
    
    

    if (movingTo.col != movingFrom.col) {
      return false;
    }

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