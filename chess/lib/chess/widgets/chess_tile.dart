import 'package:chess/chess/services/chess.dart';
import 'package:chess/chess/models/chess_piece.dart';
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
  ChessService chess = ChessService();

  @override
  void initState() {
    super.initState();
    widget.piece = _getInitialPiece();
  }

  @override
  Widget build(BuildContext context) => _buildChessTile();

  Widget _buildChessTile() => DragTarget<ChessTile>(
    onAcceptWithDetails: (details) {
      setState(() {
        if (chess.isValidMove(details.data, widget)) {
          widget.piece = details.data.piece;
          details.data.piece = null;
        }
      });
    },
    
    onWillAcceptWithDetails: (details) => true,

    builder:(context, candidateData, rejectedData) => Container(
      color: (widget.row + widget.col) % 2 == 0 ? 
      const Color.fromARGB(255, 188, 188, 188) : 
      const Color.fromARGB(255, 57, 57, 57),
      child: Center(
        child: Draggable<ChessTile>(
          onDragCompleted: () => setState(() {}),
          data: widget,
          feedback: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: DefaultTextStyle(
              style: TextStyle(
              color: widget.piece?.color,
                fontSize: 32,
              ),
            child: Text(widget.piece?.character ?? ""),
            ),
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              color: widget.piece?.color,
              fontSize: 32,
            ),
            child: Text(widget.piece?.character ?? ""),
          ),
        ),
      ),
    ),
  );

  ChessPiece? _getInitialPiece() {
    var color = widget.row < 2 ? Colors.white : Colors.black;

    if (widget.row == 1 || widget.row == 6) {
      return ChessPiece(
        character: "P", name: "Pawn", 
        color: color,
        worth: 1
      );

    } else if ((widget.row == 0 && widget.col == 0) ||
        (widget.row == 0 && widget.col == 7) ||
        (widget.row == 7 && widget.col == 0) ||
        (widget.row == 7 && widget.col == 7)) {
      return ChessPiece(
        character: "R", name: "Rook", 
        color: color,
        worth: 5
      );

    } else if ((widget.row == 0 && widget.col == 1) ||
        (widget.row == 0 && widget.col == 6) ||
        (widget.row == 7 && widget.col == 1) ||
        (widget.row == 7 && widget.col == 6)) {
      return ChessPiece(
        character: "N", name: "Knight", 
        color: color,
        worth: 3);

    } else if ((widget.row == 0 && widget.col == 2) ||
        (widget.row == 0 && widget.col == 5) ||
        (widget.row == 7 && widget.col == 2) ||
        (widget.row == 7 && widget.col == 5)) {
      return ChessPiece(
        character: "B", name: "Bishop", 
        color: color,
        worth: 3);

    } else if ((widget.row == 0 && widget.col == 3) ||
        (widget.row == 7 && widget.col == 3)) {
      return ChessPiece(
        character: "Q", name: "Queen", 
        color: color,
        worth: 9);

    } else if ((widget.row == 0 && widget.col == 4) ||
        (widget.row == 7 && widget.col == 4)) {
      return ChessPiece(
        character: "K", name: "King", 
        color: color,
        worth: 0);
    }

    return null;
  }
}
