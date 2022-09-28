import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:arcore_example/interactions/base_interaction.dart';
import 'package:vector_math/vector_math.dart';

import '../data/pokemon_states.dart';

class Dance extends BaseInteraction {
  Dance(super.firstPokemon, super.secondPokemon);

  void startDance(ARObjectManager arObjectManager, ARAnchorManager arAnchorManager) {
    var danceSteps = 5;

    for(var i = 0.0; i < danceSteps; i++ ) {
      Future.delayed(Duration(milliseconds: (500 * i).toInt()), () => _rotatePokemons90Degress(i));
    }

    _toggleDizzyness(arObjectManager, arAnchorManager, true);

    Future.delayed(const Duration(seconds: 5), () => _toggleDizzyness(arObjectManager, arAnchorManager, false));
  }

  void _toggleDizzyness(ARObjectManager arObjectManager, ARAnchorManager arAnchorManager, bool makeDizzy) {
    var state = PokemonState.neutral;

    if (makeDizzy) {
      state = PokemonState.dizzy;
    }

    firstPokemon.changeState(arObjectManager, arAnchorManager, state);
    secondPokemon.changeState(arObjectManager, arAnchorManager, state);
  }

  void _rotatePokemons90Degress(double step) {
    var rotationCopy = firstPokemon.node.rotation;
    rotationCopy.setRotationY(radians(90 * step));
    firstPokemon.node.rotation = rotationCopy;

    rotationCopy = secondPokemon.node.rotation;
    rotationCopy.setRotationY(radians(90 * step));
    secondPokemon.node.rotation = rotationCopy;
  }
}