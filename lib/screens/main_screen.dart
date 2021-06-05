import 'package:flutter/material.dart';

import 'game_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Spacer(),
          Image.asset(
            "assets/tictactoe.png",
            alignment: Alignment.center,
            height: 200,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "Spotify",
                  style: TextStyle(color: const Color(0xFF1ED760)),
                ),
                TextSpan(text: " Tic Tac Toe"),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 100),
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GameScreen()),
              ),
              child: Text("Let's play!!"),
            ),
          ),
        ],
      ),
    );
  }
}
