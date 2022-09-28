import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:arcore_example/data/pokemon_states.dart';

abstract class Pokemon {
  Map<PokemonState, ARNode> nodes = {};
  ARPlaneAnchor anchor;
  late ARNode node;

  Pokemon(this.nodes, this.anchor) {
    node = nodes[PokemonState.neutral]!;
  }

  void removeFromWorld(ARObjectManager arObjectManager, ARAnchorManager arAnchorManager) {
    arAnchorManager.removeAnchor(anchor);
    arObjectManager.removeNode(node);
    for (var node in nodes.values) {
      arObjectManager.removeNode(node);
    }
  }

  void changeState(ARObjectManager arObjectManager, ARAnchorManager arAnchorManager, PokemonState newState) {
    var newStateNode = nodes[newState];
    removeFromWorld(arObjectManager, arAnchorManager);
    node = newStateNode!;
    arAnchorManager.addAnchor(anchor);
    arObjectManager.addNode(newStateNode, planeAnchor: anchor);
  }
}