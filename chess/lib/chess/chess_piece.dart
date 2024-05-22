import 'dart:ui';

enum PieceType { pawn, rook, knight, bishop, queen, king }

class ChessPiece {
  final PieceType type;
  final Color color;
  int row;
  int column;

  ChessPiece({
    required this.type,
    required this.color,
    required this.row,
    required this.column,
  });
}
