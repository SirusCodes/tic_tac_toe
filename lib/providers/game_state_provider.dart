import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'board_provider.dart';

enum GameState { player1, player2, tie, player1Won, player2Won }

final gameStateProvider =
    StateNotifierProvider<GameStateProvider, GameState>((ref) {
  return GameStateProvider();
});

class GameStateProvider extends StateNotifier<GameState> {
  GameStateProvider() : super(GameState.player1);
  static const _winningConditions = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  void reset() {
    state = GameState.player1;
  }

  void evaluateBoard(List<BoardElement> boardState) {
    for (final condition in _winningConditions) {
      if (boardState[condition[0]] != BoardElement.none &&
          boardState[condition[0]] == boardState[condition[1]] &&
          boardState[condition[1]] == boardState[condition[2]]) {
        _playerWon();
        return;
      }
    }

    if (_isTie(boardState)) {
      state = GameState.tie;
      return;
    }

    _nextTurn();
  }

  void _nextTurn() {
    state = state == GameState.player1 ? GameState.player2 : GameState.player1;
  }

  bool _isTie(List<BoardElement> boardState) {
    for (final ele in boardState) if (ele == BoardElement.none) return false;
    return true;
  }

  void _playerWon() {
    if (state == GameState.player1)
      state = GameState.player1Won;
    else
      state = GameState.player2Won;
  }
}
