import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/board_provider.dart';
import '../providers/game_state_provider.dart';
import '../utils/players.dart';
import '../widgets/cross.dart';
import '../widgets/nought.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final boardState = watch(boardProvider);

    return ProviderListener(
      provider: gameStateProvider,
      onChange: (context, GameState state) {
        switch (state) {
          case GameState.player1:
            break;
          case GameState.player2:
            context.read(boardProvider.notifier).playForMachine(Machine());
            break;
          case GameState.tie:
            _showDialog(context, "It's a Tie⚔");
            break;
          case GameState.player1Won:
            _showDialog(context, "You won🎉");
            break;
          case GameState.player2Won:
            _showDialog(context, "Let's try again🔥");
            break;
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Text(
                  "You are playing as X",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  physics: NeverScrollableScrollPhysics(),
                  childAspectRatio: 1,
                  children: List.generate(
                    9,
                    (index) => _Field(
                      onTap: () {
                        context
                            .read(boardProvider.notifier)
                            .onPlayerMove(Human(), index);
                      },
                      child: boardState[index] == BoardElement.none
                          ? SizedBox.shrink()
                          : boardState[index] == BoardElement.cross
                              ? CrossWidget()
                              : NoughtWidget(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  result,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 25),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read(boardProvider.notifier).resetBoard();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.repeat),
                  label: Text("Restart"),
                ),
                const SizedBox(height: 5),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.exit_to_app_rounded),
                  label: Text("Quit"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    Key? key,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  final VoidCallback onTap;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: child,
        ),
      ),
    );
  }
}
