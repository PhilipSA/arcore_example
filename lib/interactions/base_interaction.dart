import 'package:ar_flutter_plugin/models/ar_node.dart';

abstract class BaseInteraction {
  late ARNode firstPokemon;
  late ARNode secondPokemon;

  BaseInteraction(this.firstPokemon, this.secondPokemon);
}