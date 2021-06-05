import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/players.dart';
import 'game_state_provider.dart';

enum BoardElement { none, cross, nought }

final boardProvider =
    StateNotifierProvider<BoardProvider, List<BoardElement>>((ref) {
  return BoardProvider(ref.read);
});

class BoardProvider extends StateNotifier<List<BoardElement>> {
  BoardProvider(Reader read) : super(_initState) {
    _gameState = read(gameStateProvider.notifier);
  }

  late GameStateProvider _gameState;

  static List<BoardElement> get _initState =>
      List.generate(9, (index) => BoardElement.none);

  final rand = Random();

  void onPlayerMove(Player player, int position) {
    if (state[position] != BoardElement.none) return;

    final newState = [...state];
    newState[position] = player.boardElement;
    state = newState;

    _gameState.evaluateBoard(state);
  }

  void playForMachine(Machine player) {
    final newState = [...state];
    int move = rand.nextInt(8);
    while (newState[move] != BoardElement.none) //
      move = rand.nextInt(8);

    onPlayerMove(player, move);
  }

  void resetBoard() {
    _gameState.reset();
    state = _initState;
  }
}
