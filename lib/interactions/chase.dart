import 'package:vector_math/vector_math_64.dart';

import 'base_interaction.dart';

class Chase extends BaseInteraction {
  Chase(super.firstPokemon, super.secondPokemon);

  void startChase() {
    var chaseSteps = 5;

    for (var i = 1; i < chaseSteps; i++) {
      Future.delayed(Duration(milliseconds: (500 * i).toInt()),
          () => _movePokemonsForward(0.1));
    }
  }

  void _movePokemonsForward(double step) {
    firstPokemon.node.position = Vector3(firstPokemon.node.position.x + step,
        firstPokemon.node.position.y, firstPokemon.node.position.z);
    secondPokemon.node.position = Vector3(secondPokemon.node.position.x + step,
        secondPokemon.node.position.y, secondPokemon.node.position.z);
  }
}
