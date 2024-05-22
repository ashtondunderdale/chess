import 'package:flutter/material.dart';

import 'chess/board.dart';


void main() => runApp(const Chess());

class Chess extends StatelessWidget {
  const Chess({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ChessBoard() 
  ); 
}
