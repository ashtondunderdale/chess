import 'dart:math';

import 'package:chess/chess/computer_engine.dart';
import 'package:chess/chess/game_result_screen.dart';
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
  final _computer = ComputerEngine();

  final _player = AudioPlayer();
  
  final _boardTheme = BoardTheme(squareTheme: "default");

  late List<List<ChessPiece?>> boardState;

  List<ChessPiece> capturedLightPieces = [];
  List<ChessPiece> capturedDarkPieces = [];

  ChessPiece? selectedPiece;
  List<List<int>> selectedPieceValidMoves = [];

  bool isWhiteMove = true;
  Color? colorInCheck;
  bool whitePiecesAtBottom = true;

  bool isPlayingAgainstComputer = true;

  @override
  void initState() {
    super.initState();
    playAudio("audio/game_start.mp3");

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

  void _resetGame() {
    setState(() {
      capturedLightPieces.clear();
      capturedDarkPieces.clear();
      selectedPiece = null;
      selectedPieceValidMoves.clear();
      isWhiteMove = true;
      colorInCheck = null;
      playAudio("audio/game_start.mp3");
      _initializeBoard();
    });
  }

  void _flipBoard() {
    setState(() {
      whitePiecesAtBottom = !whitePiecesAtBottom;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _resetGame();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 72, 72, 72),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Reset Board",
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _flipBoard,
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 72, 72, 72),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Flip Board",
                  style: TextStyle(fontSize: 12),
                ),
              ),              
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _boardTheme.updateTheme();
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 72, 72, 72),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Change Theme",
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isPlayingAgainstComputer = !isPlayingAgainstComputer;
                    _resetGame();
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 72, 72, 72),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  isPlayingAgainstComputer ? "Computer Mode" : "2 Player Mode",
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          _buildCapturedPieceList(whitePiecesAtBottom ? capturedLightPieces : capturedDarkPieces),
          Container(
            width: 540, height: 540,
            decoration: BoxDecoration(border: Border.all(color: boardBorderColor, width: 2)),
            child: GridView.builder(
              itemCount: 64,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemBuilder: (context, index) {
                final row = whitePiecesAtBottom ? index ~/ 8 : 7 - (index ~/ 8);
                final column = whitePiecesAtBottom ? index % 8 : 7 - (index % 8);
          
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

                      ChessPiece? capturedPieceOrNull = _engine.makeMove(movedPiece.data, row, column, boardState);
                      tryCapturePiece(capturedPieceOrNull);                 
                      handleGameOver(capturedPieceOrNull);
                      isWhiteMove = !isWhiteMove;
                      setState(() {

                      });

                      var rand = Random();
                      var randomDuration = Duration(milliseconds: 500 + rand.nextInt(1000));

                      await Future.delayed(randomDuration);

                      if (isPlayingAgainstComputer && !isWhiteMove) {
                        ChessPiece? capturedPieceOrNull = _computer.generateRandomMove(boardState, isWhiteMove, colorInCheck);
                        tryCapturePiece(capturedPieceOrNull);
                        handleGameOver(capturedPieceOrNull);
                        isWhiteMove = !isWhiteMove;
                      }

                      setState(() {});
                    },
                    builder: (context, candidateData, rejectedData) => _buildSquare(row, column, piece, isWhiteSquare),
                  ),
                );
              },
            ),
          ),
          _buildCapturedPieceList(whitePiecesAtBottom ? capturedDarkPieces : capturedLightPieces),
        ],
      ),
    ),
  );

  void handleGameOver(ChessPiece? capturedPieceOrNull) async {
    colorInCheck = _engine.getColorInCheck(boardState);
    Color? checkmateColor = _engine.getCheckmateColor(boardState, isWhiteMove);
    Color? stalemateColor = _engine.getStalemateColor(boardState, isWhiteMove);

    await handleGameSounds(colorInCheck, checkmateColor, capturedPieceOrNull, stalemateColor);

    if (stalemateColor != null || checkmateColor != null) {
      showDialog(context: context,
        builder: (BuildContext context) => GameResultScreen(
          isStalemate: stalemateColor != null, winningColor: checkmateColor, 
          onExitScreen: () {
            Navigator.of(context).pop();
            _resetGame();
          }, 
        ),
      );
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
      squareColor = isWhiteSquare ? _boardTheme.lightSquareColor : _boardTheme.darkSquareColor;
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
        return Image.asset('images/default/pawn_$pieceColor.png', width: 50, height: 50);
      case PieceType.rook:
        return Image.asset('images/default/rook_$pieceColor.png', width: 50, height: 50);
      case PieceType.knight:
        return Image.asset('images/default/knight_$pieceColor.png', width: 50, height: 50);
      case PieceType.bishop:
        return Image.asset('images/default/bishop_$pieceColor.png', width: 50, height: 50);
      case PieceType.queen:
        return Image.asset('images/default/queen_$pieceColor.png', width: 50, height: 50);
      case PieceType.king:
        return Image.asset('images/default/king_$pieceColor.png', width: 50, height: 50);
      default:
        return Image.asset('', width: 50, height: 50);
    }
  }

  Future handleGameSounds(Color? colorInCheck, Color? checkmateColor, ChessPiece? capturedPieceOrNull, Color? stalemateColor) async {
    if (colorInCheck != null && checkmateColor == null) {
      await playAudio("audio/check.mp3");
    } else if (capturedPieceOrNull != null && checkmateColor == null) {
      await playAudio("audio/capture_piece.mp3");
    } else if (capturedPieceOrNull == null && checkmateColor == null) {
      await playAudio("audio/piece_move.mp3");
    } else if (checkmateColor == null && stalemateColor != null) {
      await playAudio("audio/game_end.mp3");
    } else {
      await playAudio("audio/checkmate_with_check.mp3");
    }
  }

  Future playAudio(String path) async {
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
