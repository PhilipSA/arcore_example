import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';

class Pokemon {
  ARNode node;
  ARPlaneAnchor anchor;

  Pokemon(this.node, this.anchor);

  void removeFromWorld(ARObjectManager arObjectManager, ARAnchorManager arAnchorManager) {
    arAnchorManager.removeAnchor(anchor);
    arObjectManager.removeNode(node);
  }
}