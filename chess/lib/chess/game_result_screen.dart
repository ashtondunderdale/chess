import 'package:flutter/material.dart';

class GameResultScreen extends StatelessWidget {
  const GameResultScreen({super.key, required this.onExitScreen, required this.isStalemate, this.winningColor});

  final VoidCallback onExitScreen;
  final bool isStalemate;
  final Color? winningColor;
  
  final TextStyle titleStyle = const TextStyle(
    color: Color.fromARGB(255, 72, 72, 72),
    fontWeight: FontWeight.bold,
    fontSize: 32,
  );
  final TextStyle contentStyle = const TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );
  final TextStyle subContentStyle = const TextStyle(
    color: Color.fromARGB(255, 191, 191, 191),
    fontSize: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Game Over",
              style: titleStyle,
            ),
            const SizedBox(height: 20),
            if (!isStalemate)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    winningColor == Colors.white ? 'White Wins' : 'Black Wins',
                    style: contentStyle,
                  ),
                  Text(
                    "by checkmate",
                    style: subContentStyle,
                  ),
                ],
              )
            else
              Text(
                "Stalemate",
                style: contentStyle,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onExitScreen();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 72, 72, 72),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                "Play Again",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}