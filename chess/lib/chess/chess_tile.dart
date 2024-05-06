import 'package:chess/chess/piece_model.dart';
import 'package:flutter/material.dart';

class ChessTile extends StatefulWidget {
  ChessTile({Key? key, required this.row, required this.col}) : super(key: key);

  final int row;
  final int col;
  late ChessPiece? piece;

  @override
  State<ChessTile> createState() => _ChessTileState();
}

class _ChessTileState extends State<ChessTile> {

  @override
  void initState() {
    super.initState();
    widget.piece = _getInitialPiece();
  }

  @override
  Widget build(BuildContext context) => DragTarget<ChessTile>(
    onAcceptWithDetails: (details) {
      setState(() {
        widget.piece = details.data.piece;
      });
    },
    builder:(context, candidateData, rejectedData) => Container(
      color: (widget.row + widget.col) % 2 == 0 ? const Color.fromARGB(255, 188, 188, 188) : const Color.fromARGB(255, 33, 33, 33),
      child: Center(
        child: Draggable<ChessTile>(
          onDragCompleted: () {
            setState(() {
              widget.piece = null;
            });
          },
          data: widget,
          feedback: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: DefaultTextStyle(
              style: TextStyle(
              color: widget.piece?.color,
                fontSize: 48,
              ),
            child: Text(widget.piece?.character ?? ""),
            ),
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              color: widget.piece?.color,
              fontSize: 48,
            ),
            child: Text(widget.piece?.character ?? ""),
          ),
        ),
      ),
    ),
  );

  ChessPiece? _getInitialPiece() {
    if (widget.row == 1 || widget.row == 6) {
      return ChessPiece(character: "P", name: "Pawn", color: widget.row == 1 ? Colors.white : Colors.black);
    } else if ((widget.row == 0 && widget.col == 0) ||
        (widget.row == 0 && widget.col == 7) ||
        (widget.row == 7 && widget.col == 0) ||
        (widget.row == 7 && widget.col == 7)) {
      return ChessPiece(character: "R", name: "Rook", color: widget.row == 0 ? Colors.white : Colors.black);
    } else if ((widget.row == 0 && widget.col == 1) ||
        (widget.row == 0 && widget.col == 6) ||
        (widget.row == 7 && widget.col == 1) ||
        (widget.row == 7 && widget.col == 6)) {
      return ChessPiece(character: "N", name: "Knight", color: widget.row == 0 ? Colors.white : Colors.black);
    } else if ((widget.row == 0 && widget.col == 2) ||
        (widget.row == 0 && widget.col == 5) ||
        (widget.row == 7 && widget.col == 2) ||
        (widget.row == 7 && widget.col == 5)) {
      return ChessPiece(character: "B", name: "Bishop", color: widget.row == 0 ? Colors.white : Colors.black);
    } else if ((widget.row == 0 && widget.col == 3) ||
        (widget.row == 7 && widget.col == 3)) {
      return ChessPiece(character: "Q", name: "Queen", color: widget.row == 0 ? Colors.white : Colors.black);
    } else if ((widget.row == 0 && widget.col == 4) ||
        (widget.row == 7 && widget.col == 4)) {
      return ChessPiece(character: "K", name: "King", color: widget.row == 0 ? Colors.white : Colors.black);
    }

    return null;
  }

}
