import 'package:chess/chess/widgets/captured_piece_list.dart';
import 'package:chess/constants.dart';
import 'package:flutter/material.dart';

import '../models/chess_piece.dart';
import 'chess_tile.dart';

class ChessBoard extends StatefulWidget {
  ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
List<ChessPiece> capturedPieces = <ChessPiece>[];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 100, height: 40, child: CapturedPieceList(pieces: capturedPieces)),
          Container(
            width: boardSize,
            height: boardSize,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2)
            ),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemBuilder: (BuildContext context, int index) {
                int row = index ~/ 8;
                int col = index % 8;
            
                return ChessTile(row: row, col: col, onPieceCaptured: (piece) {
                  capturedPieces.add(piece);
                });
              },
              itemCount: 64,
            ),
          ),
        ],
      ),
    ),
  );
}
