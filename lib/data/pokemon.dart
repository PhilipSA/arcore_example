import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:arcore_example/data/pokemon_states.dart';

abstract class Pokemon {
  Map<PokemonState, ARNode> nodes = {};
  ARPlaneAnchor anchor;
  late ARNode node;

  Pokemon(this.nodes, this.anchor, ARObjectManager arObjectManager) {
    node = nodes[PokemonState.neutral]!;
    _addNodeToManager(arObjectManager);
  }

  void _addNodeToManager(ARObjectManager arObjectManager) async {
    await arObjectManager.addNode(node, planeAnchor: anchor);
  }

  Future<void> removeFromWorld(ARObjectManager arObjectManager, ARAnchorManager arAnchorManager) async {
    await arAnchorManager.removeAnchor(anchor);
    await arObjectManager.removeNode(node);
    for (var node in nodes.values) {
      await arObjectManager.removeNode(node);
    }
  }

  Future<void> changeState(ARObjectManager arObjectManager, ARAnchorManager arAnchorManager, PokemonState newState) async {
    var newStateNode = nodes[newState];
    removeFromWorld(arObjectManager, arAnchorManager);
    node = newStateNode!;
    await arAnchorManager.addAnchor(anchor);
    await arObjectManager.addNode(newStateNode, planeAnchor: anchor);
  }
}