import 'dart:ui';

enum PieceType { pawn, rook, knight, bishop, queen, king }

class ChessPiece {
  final PieceType type;
  final Color color;

  ChessPiece({required this.type, required this.color});
}
