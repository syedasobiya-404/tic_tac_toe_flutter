import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/game_screen.dart';

void main() {
  runApp(const TicTacToe());
}

class TicTacToe extends StatelessWidget {
  const TicTacToe({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Coiny",
        textTheme: TextTheme(
          titleMedium: TextStyle(
            color: Colors.white,
            fontSize: 24,
            letterSpacing: 3,
          ),
        ),
      ),
      home: GameScreen(),
    );
  }
}
