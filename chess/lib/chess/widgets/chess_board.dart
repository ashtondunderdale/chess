import 'package:chess/constants.dart';
import 'package:flutter/material.dart';

import 'chess_tile.dart';

class ChessBoard extends StatelessWidget {
  const ChessBoard({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Container(
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
        
            return ChessTile(row: row, col: col);
          },
          itemCount: 64,
        ),
      ),
    ),
  );
}
