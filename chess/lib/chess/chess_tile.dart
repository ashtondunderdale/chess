import 'package:flutter/material.dart';

class ChessTile extends StatefulWidget {
  ChessTile({Key? key, required this.row, required this.col}) : super(key: key);

  final int row;
  final int col;

  @override
  State<ChessTile> createState() => _ChessTileState();
}

class _ChessTileState extends State<ChessTile> {
  late String piece;

  @override
  Widget build(BuildContext context) => Container(
        color: (widget.row + widget.col) % 2 == 0 ? Colors.white : Colors.black,
        child: Center(
          child: Draggable<ChessTile>(
            feedback: Container(
              decoration: BoxDecoration(
                color: Colors.transparent, // Set the background color to transparent
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: (widget.row + widget.col) % 2 != 0 ? Colors.white : Colors.black,
                  fontSize: 48,
                ),
                child: Text(_getInitialPiece()),
              ),
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                color: (widget.row + widget.col) % 2 != 0 ? Colors.white : Colors.black,
                fontSize: 48,
              ),
              child: Text(_getInitialPiece()),
            ),
          ),
        ),
      );

  String _getInitialPiece() {
    if (widget.row == 1 || widget.row == 6) {
      return "P";
    } else if ((widget.row == 0 && widget.col == 0) ||
        (widget.row == 0 && widget.col == 7) ||
        (widget.row == 7 && widget.col == 0) ||
        (widget.row == 7 && widget.col == 7)) {
      return "R";
    } else if ((widget.row == 0 && widget.col == 1) ||
        (widget.row == 0 && widget.col == 6) ||
        (widget.row == 7 && widget.col == 1) ||
        (widget.row == 7 && widget.col == 6)) {
      return "N";
    } else if ((widget.row == 0 && widget.col == 2) ||
        (widget.row == 0 && widget.col == 5) ||
        (widget.row == 7 && widget.col == 2) ||
        (widget.row == 7 && widget.col == 5)) {
      return "B";
    } else if ((widget.row == 0 && widget.col == 3) ||
        (widget.row == 7 && widget.col == 3)) {
      return "Q";
    } else if ((widget.row == 0 && widget.col == 4) ||
        (widget.row == 7 && widget.col == 4)) {
      return "K";
    }

    return "";
  }
}
