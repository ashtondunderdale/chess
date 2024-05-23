import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';

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
  final _player = AudioPlayer();

  late List<List<ChessPiece?>> boardState;

  List<ChessPiece> capturedLightPieces = [];
  List<ChessPiece> capturedDarkPieces = [];

  ChessPiece? selectedPiece;
  List<List<int>> selectedPieceValidMoves = [];

  bool isWhiteMove = true;
  Color? colorInCheck;

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
                      if (selectedPiece == piece) {
                        selectedPiece = null;
                        selectedPieceValidMoves = [];
                      } else {
                        selectedPieceValidMoves = [];
                        selectedPiece = piece;
                      }

                      if (selectedPiece == null) {
                        return;
                      }

                      if (selectedPiece!.type == PieceType.pawn) {
                        selectedPieceValidMoves = _engine.getValidPawnMoves(selectedPiece!, boardState);
                      } else if (selectedPiece!.type == PieceType.knight) {
                        selectedPieceValidMoves = _engine.getValidKnightMoves(selectedPiece!, boardState);
                      } else if (selectedPiece!.type == PieceType.bishop) {
                        selectedPieceValidMoves = _engine.getValidBishopMoves(selectedPiece!, boardState);
                      } else if (selectedPiece!.type == PieceType.rook) {
                        selectedPieceValidMoves = _engine.getValidRookMoves(selectedPiece!, boardState);
                      } else if (selectedPiece!.type == PieceType.queen) {
                        selectedPieceValidMoves = _engine.getValidQueenMoves(selectedPiece!, boardState);
                      } else if (selectedPiece!.type == PieceType.king) {
                        selectedPieceValidMoves = _engine.getValidKingMoves(selectedPiece!, boardState);
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
                    onAcceptWithDetails: (movedPiece) async {
                      selectedPieceValidMoves = [];

                      if (!_engine.isValidMove(movedPiece.data, row, column, boardState, colorInCheck)) {
                        return;
                      }

                      if (!_engine.isCorrectPlayerTurn(isWhiteMove, movedPiece.data)) {
                        return;
                      }

                      isWhiteMove = !isWhiteMove;

                      ChessPiece? capturedPieceOrNull = _engine.makeMove(movedPiece.data, row, column, boardState);
                      tryCapturePiece(capturedPieceOrNull);

                      colorInCheck = _engine.getColorInCheck(boardState);
                      Color? checkmateColor = _engine.getCheckmateColor(boardState, isWhiteMove);
                      Color? stalemateColor = _engine.getDrawColor(boardState, isWhiteMove);

                      if (colorInCheck != null && checkmateColor == null) {
                        playAudio("audio/check.mp3");
                      } else if (capturedPieceOrNull != null && checkmateColor == null) {
                        playAudio("audio/capture_piece.mp3");
                      } else if (capturedPieceOrNull == null && checkmateColor == null) {
                        playAudio("audio/piece_move.mp3");
                      } else if (checkmateColor == null && stalemateColor != null) {
                        playAudio("audio/game_end.mp3");
                      } else {
                        playAudio("audio/checkmate_with_check.mp3");
                      }

                      handleGameSounds(colorInCheck, checkmateColor, capturedPieceOrNull, stalemateColor);

                      if (stalemateColor != null) {
                        print("stalemate");
                      }

                      if (checkmateColor != null) {
                        print(checkmateColor == Colors.white ?  " white wins" : "black wins");
                      }

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

  void handleGameSounds(Color? colorInCheck, Color? checkmateColor, ChessPiece? capturedPieceOrNull, Color? stalemateColor) {
    if (checkmateColor != null) {
      playAudio("audio/checkmate_with_check.mp3");
    } else if (colorInCheck != null) {
      playAudio("audio/check.mp3");
    } else if (stalemateColor != null) {
      playAudio("audio/game_end.mp3");
    } else if (capturedPieceOrNull != null) {
      playAudio("audio/capture_piece.mp3");
    } else {
      playAudio("audio/piece_move.mp3");
    }
  }

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
    } else {
      squareColor = isWhiteSquare ? lightSquareColor : darkSquareColor;
    }

    return Container(
      decoration: BoxDecoration(color: squareColor),
      child: piece != null ? _buildDraggablePiece(piece) : isValidMove ? 
        Center(
          child: Container(
            width: 20, height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: selectedPieceValidMoveColor
            ),
          ),
        ) 
        : null,
    );
  }

  Widget _buildCapturedPieceList(List<ChessPiece> pieces) => Padding(
    padding: const EdgeInsets.all(16),
    child: SizedBox(
      width: 800, height: 80,
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
        return Image.asset('images/pawn_$pieceColor.png', width: 50, height: 50);
      case PieceType.rook:
        return Image.asset('images/rook_$pieceColor.png', width: 50, height: 50);
      case PieceType.knight:
        return Image.asset('images/knight_$pieceColor.png', width: 50, height: 50);
      case PieceType.bishop:
        return Image.asset('images/bishop_$pieceColor.png', width: 50, height: 50);
      case PieceType.queen:
        return Image.asset('images/queen_$pieceColor.png', width: 50, height: 50);
      case PieceType.king:
        return Image.asset('images/king_$pieceColor.png', width: 50, height: 50);
      default:
        return Image.asset('', width: 50, height: 50);
    }
  }

  void playAudio(String path) async {
    if (await _assetExists(path)) {
      try {
        await _player.setAudioSource(AudioSource.asset(path));
        await _player.play();

      } catch (exception) {
        print("Error playing audio: $exception");
      }
    } else {
      print("Audio asset not found: $path");
    }
  }
  
  Future<bool> _assetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }
}
