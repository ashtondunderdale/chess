import 'package:flutter/material.dart';

class ChessBoard extends StatelessWidget {
  const ChessBoard({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Container(
        width: 600, height: 600,
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: GridView.builder(
          itemCount: 64,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
          ),
          itemBuilder: (context, index) {
            final row = index ~/ 8;
            final column = index % 8;
            final isWhite = (row + column) % 2 == 0;
          
            final position = Vector2(x: row, y: column);

            return Container(
              decoration: BoxDecoration(
                color: isWhite ? Colors.white : Colors.black,
              ),
            );
          },
        ),
      ),
    ),
  );
}

class Vector2 {
  final int x;
  final int y;

  Vector2({
    required this.x,
    required this.y
  });
}

class ChessPiece {
  
}