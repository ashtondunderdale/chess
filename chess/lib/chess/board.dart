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

  List<ChessPiece> capturedLightPieces = [];
  List<ChessPiece> capturedDarkPieces = [];

  ChessPiece? selectedPiece;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    boardState = List.generate(8, (i) => List.filled(8, null));

    for (int i = 0; i < 8; i++) {
      boardState[1][i] = ChessPiece(
        type: PieceType.pawn,
        color: Colors.black,
        row: 1,
        column: i,
      );
      boardState[6][i] = ChessPiece(
        type: PieceType.pawn,
        color: Colors.white,
        row: 6,
        column: i,
      );
    }

    final pieceOrder = [
      PieceType.rook, PieceType.knight, PieceType.bishop, PieceType.queen,
      PieceType.king, PieceType.bishop, PieceType.knight, PieceType.rook
    ];

    for (int i = 0; i < 8; i++) {
      boardState[0][i] = ChessPiece(
        type: pieceOrder[i],
        color: Colors.black,
        row: 0,
        column: i,
      );
      boardState[7][i] = ChessPiece(
        type: pieceOrder[i],
        color: Colors.white,
        row: 7,
        column: i,
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCapturedPieceList(capturedLightPieces),
          Container(
            width: 600, height: 600,
            decoration: BoxDecoration(border: Border.all(color: boardBorderColor, width: 2)),
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
          
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPiece = piece;
                    });
                  },
                  child: DragTarget<ChessPiece>(
                    onWillAcceptWithDetails: (data) {
                      return true;
                    },
                    onAcceptWithDetails: (movedPiece) {
                      setState(() {
                        boardState[movedPiece.data.row][movedPiece.data.column] = null;
                        
                        movedPiece.data.row = row;
                        movedPiece.data.column = column;
                  
                        var capturedPiece = boardState[row][column];
                        boardState[row][column] = movedPiece.data;

                      });
                    },
                    builder: (context, candidateData, rejectedData) => Container(
                      decoration: BoxDecoration(
                        color: piece == selectedPiece && selectedPiece != null ? const Color.fromARGB(255, 142, 142, 142) : isWhite ? lightSquareColor : darkSquareColor,
                      ),
                      child: piece != null ? _buildDraggablePiece(piece) : null,
                    ),
                  ),
                );
              },
            ),
          ),
          _buildCapturedPieceList(capturedDarkPieces),
        ],
      ),
    ),
  );

  Widget _buildCapturedPieceList(List<ChessPiece> pieces) => Padding(
    padding: const EdgeInsets.all(16),
    child: Container(
      width: 800,
      height: 80,
      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: pieces.map((piece) => _buildPiece(piece)).toList(),
        ),
      )
    ),
  );

  Widget _buildDraggablePiece(ChessPiece piece)  => Draggable<ChessPiece>(
    data: piece,
    feedback: _buildPiece(piece),
    childWhenDragging: Container(),
    child: _buildPiece(piece),
  );

  Image _buildPiece(ChessPiece piece) {
    final pieceColor = piece.color == Colors.white ? 'white' : 'black';
    switch (piece.type) {
      case PieceType.pawn:
        return Image.asset('pawn_$pieceColor.png', width: 50, height: 50);
      case PieceType.rook:
        return Image.asset('rook_$pieceColor.png', width: 50, height: 50);
      case PieceType.knight:
        return Image.asset('knight_$pieceColor.png', width: 50, height: 50);
      case PieceType.bishop:
        return Image.asset('bishop_$pieceColor.png', width: 50, height: 50);
      case PieceType.queen:
        return Image.asset('queen_$pieceColor.png', width: 50, height: 50);
      case PieceType.king:
        return Image.asset('king_$pieceColor.png', width: 50, height: 50);
      default:
        return Image.asset('', width: 50, height: 50);
    }
  }
}