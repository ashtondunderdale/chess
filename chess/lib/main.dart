import 'package:chess/chess/widgets/chess_board.dart';
import 'package:flutter/material.dart';


void main() => runApp(const Chess());

class Chess extends StatelessWidget {
  const Chess({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ChessBoard(),
  ); 
}
