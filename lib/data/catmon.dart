import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:arcore_example/data/pokemon.dart';
import 'package:arcore_example/data/pokemon_states.dart';
import 'package:vector_math/vector_math_64.dart';

class Catmon extends Pokemon {
  Catmon(ARObjectManager arObjectManager, ARPlaneAnchor anchor, Vector3 startingPosition)
      : super(generateStateNodes(startingPosition), anchor, arObjectManager);

  static Map<PokemonState, ARNode> generateStateNodes(
      Vector3 startingPosition) {
    var neutralAsset = "cat_neutral.glb";
    var dizzyAsset = "cat_dizzy.glb";

    var neutralNode = ARNode(
        type: NodeType.fileSystemAppFolderGLB,
        uri: neutralAsset,
        scale: Vector3(1, 1, 1),
        position: startingPosition,
        rotation: Vector4(1.0, 0.0, 0.0, 0.0));

    var dizzyNode = ARNode(
        type: NodeType.fileSystemAppFolderGLB,
        uri: dizzyAsset,
        scale: Vector3(1, 1, 1),
        position: startingPosition,
        rotation: Vector4(1.0, 0.0, 0.0, 0.0));

    return {PokemonState.neutral: neutralNode, PokemonState.dizzy: dizzyNode};
  }
}
