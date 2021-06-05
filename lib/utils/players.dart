import '../providers/board_provider.dart';

abstract class Player {
  const Player();
  BoardElement get boardElement;
}

class Human extends Player {
  const Human();
  @override
  BoardElement get boardElement => BoardElement.cross;
}

class Machine extends Player {
  const Machine();
  @override
  BoardElement get boardElement => BoardElement.nought;
}
