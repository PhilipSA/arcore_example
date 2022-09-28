import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:arcore_example/data/pokemon.dart';

abstract class BaseInteraction {
  late Pokemon firstPokemon;
  late Pokemon secondPokemon;

  BaseInteraction(this.firstPokemon, this.secondPokemon);
}