import 'package:flutter/material.dart';
import '../constants.dart';
import 'chess_piece.dart';


class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  late List<List<ChessPiece?>> boardState;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    boardState = List.generate(8, (i) => List.filled(8, null));

    for (int i = 0; i < 8; i++) {
      boardState[1][i] = ChessPiece(type: PieceType.pawn, color: Colors.black);
      boardState[6][i] = ChessPiece(type: PieceType.pawn, color: Colors.white);
    }

    final pieceOrder = [
      PieceType.rook, PieceType.knight, PieceType.bishop, PieceType.queen,
      PieceType.king, PieceType.bishop, PieceType.knight, PieceType.rook
    ];

    for (int i = 0; i < 8; i++) {
      boardState[0][i] = ChessPiece(type: pieceOrder[i], color: Colors.black);
      boardState[7][i] = ChessPiece(type: pieceOrder[i], color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Container(
        width: 600, height: 600,
        decoration: BoxDecoration(border: Border.all(color: boardBorderColor)),
        child: GridView.builder(
          itemCount: 64,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
          ),
          itemBuilder: (context, index) {
            final row = index ~/ 8;
            final column = index % 8;
            
            final isWhite = (row + column) % 2 == 0;
            final piece = boardState[row][column];

            return Container(
              decoration: BoxDecoration(
                color: isWhite ? darkSquareColor : lightSquareColor,
              ),
              child: piece != null ? _buildPiece(piece) : null,
            );
          },
        ),
      ),
    ),
  );

  Image _buildPiece(ChessPiece piece) {
    final pieceColor = piece.color == Colors.white ? 'white' : 'black';
    switch (piece.type) {
      case PieceType.pawn:
        return Image.asset('pawn_$pieceColor.png');
      case PieceType.rook:
        return Image.asset('rook_$pieceColor.png');
      case PieceType.knight:
        return Image.asset('knight_$pieceColor.png');
      case PieceType.bishop:
        return Image.asset('bishop_$pieceColor.png');
      case PieceType.queen:
        return Image.asset('queen_$pieceColor.png');
      case PieceType.king:
        return Image.asset('king_$pieceColor.png');
      default:
        return Image.asset(''); 
    }
  }
}
