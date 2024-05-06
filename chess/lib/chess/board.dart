import 'package:flutter/material.dart';

import 'chess_tile.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  final double boardSize = 600;

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Container(
        width: widget.boardSize,
        height: widget.boardSize,
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
