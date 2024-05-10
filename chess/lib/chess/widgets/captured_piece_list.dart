import 'package:flutter/material.dart';

import '../models/chess_piece.dart';

class CapturedPieceList extends StatelessWidget {
  CapturedPieceList({super.key, required this.pieces});

  List<ChessPiece> pieces;

  @override
  Widget build(BuildContext context) => Container(
    width: 200,
    height: 200,
    child: ListView.builder(
      itemCount: pieces.length,
      itemBuilder: (context, index) => ListTile(
          title: Text(pieces.first.character,
      ),
    ),
  ));
}