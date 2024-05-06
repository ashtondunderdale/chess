import 'package:flutter/material.dart';

class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Container(
        width: 700,
        height: 700,
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
            Color color = (row + col) % 2 == 0 ? Colors.white : Colors.black;
        
            return Container(color: color);
          },
          itemCount: 64,
        ),
      ),
    ),
  );
}
