import 'package:flutter/material.dart';
import '../constants.dart';
import 'chess_engine.dart';
import 'chess_piece.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  final _engine = ChessEngine();

  late List<List<ChessPiece?>> boardState;

  List<ChessPiece> capturedLightPieces = [];
  List<ChessPiece> capturedDarkPieces = [];

  ChessPiece? selectedPiece;
  List<List<int>> selectedPieceValidMoves = [];

  bool isWhiteMove = true;

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
          
                final isWhiteSquare = (row + column) % 2 == 0;
                final piece = boardState[row][column];
          
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPieceValidMoves = [];
                      selectedPiece = piece;

                      if (selectedPiece == null) {
                        return;
                      }

                      if (selectedPiece!.type == PieceType.pawn) {
                        selectedPieceValidMoves = _engine.getValidPawnMoves(selectedPiece!, boardState);
                      } else if (selectedPiece!.type == PieceType.knight) {
                        selectedPieceValidMoves = _engine.getValidKnightMove(selectedPiece!, boardState);
                      } else if (selectedPiece!.type == PieceType.bishop) {
                        selectedPieceValidMoves = _engine.getValidBishopMove(selectedPiece!, boardState);
                      } else if (selectedPiece!.type == PieceType.rook) {
                        selectedPieceValidMoves = _engine.getValidRookMove(selectedPiece!, boardState);
                      } else if (selectedPiece!.type == PieceType.queen) {
                        selectedPieceValidMoves = _engine.getValidQueenMove(selectedPiece!, boardState);
                      }
                    });
                  },
                  child: DragTarget<ChessPiece>(
                    onWillAcceptWithDetails: (data) {
                      setState(() {
                        if (selectedPiece != data.data) {
                          selectedPieceValidMoves = [];
                        }        
                        
                        selectedPiece = data.data;  
                      });
                      return true;
                    },
                    onAcceptWithDetails: (movedPiece) {
                      selectedPieceValidMoves = [];

                      if (!_engine.isValidMove(movedPiece.data, row, column, boardState)) {
                        return;
                      }

                      if (!_engine.isCorrectPlayerTurn(isWhiteMove, movedPiece.data)) {
                        return;
                      }

                      isWhiteMove = !isWhiteMove;

                      ChessPiece? capturedPieceOrNull = _engine.makeMove(movedPiece.data, row, column, boardState);
                      tryCapturePiece(capturedPieceOrNull);

                      setState(() {});
                    },
                    builder: (context, candidateData, rejectedData) => _buildSquare(row, column, piece, isWhiteSquare),
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

  void tryCapturePiece(ChessPiece? capturedPiece) {
    if (capturedPiece == null) {
      return;
    } 

    if (capturedPiece.color == Colors.white) {
      capturedLightPieces.add(capturedPiece);
    } else {
      capturedDarkPieces.add(capturedPiece);
    }
  }

  Widget _buildSquare(int row, int column, ChessPiece? piece, bool isWhiteSquare) {
    bool isValidMove = selectedPieceValidMoves.any((move) => move[0] == row && move[1] == column);

    Color squareColor;
    if (piece == selectedPiece && selectedPiece != null) {
      squareColor = selectedPieceColor;
    } else if (isValidMove) {
      squareColor = selectedPieceValidMoveColor;
    } else {
      squareColor = isWhiteSquare ? lightSquareColor : darkSquareColor;
    }

    return Container(
      decoration: BoxDecoration(color: squareColor),
      child: piece != null ? _buildDraggablePiece(piece) : null,
    );
  }

  Widget _buildCapturedPieceList(List<ChessPiece> pieces) => Padding(
    padding: const EdgeInsets.all(16),
    child: SizedBox(
      width: 800,
      height: 80,
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
    childWhenDragging: const SizedBox(),
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
