import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:arcore_example/data/pokemon.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:vector_math/vector_math_64.dart';

class WorldState extends ChangeNotifier {
  List<Pokemon> otherPokemons = [];
  Pokemon? myPokemon;

  void populateWorld(ARObjectManager arObjectManager, ARAnchorManager arAnchorManager, List<ARHitTestResult> hitTestResults) {
    hitTestResults.forEachIndexed((index, element) {
      var myPokemonAnchorCopy = ARPlaneAnchor(transformation: myPokemon!.anchor.transformation);
      arAnchorManager.addAnchor(myPokemonAnchorCopy);

      var otherPokemonNode = ARNode(
          type: NodeType.localGLTF2,
          uri:
          "assets/Chicken_01/Chicken_01.gltf",
          scale: Vector3(0.2, 0.2, 0.2),
          position: Vector3(index + myPokemon!.node.position.x, myPokemon!.node.position.y, myPokemon!.node.position.z),
          rotation: Vector4(1.0, 0.0, 0.0, 0.0));
      arObjectManager.addNode(otherPokemonNode, planeAnchor: myPokemonAnchorCopy);

      var otherPokemon = Pokemon(otherPokemonNode, myPokemonAnchorCopy);
      otherPokemons.add(otherPokemon);
    });

    notifyListeners();
  }

  Future<bool> iChoseYou(ARPlaneAnchor newAnchor, ARObjectManager arObjectManager, ARAnchorManager arAnchorManager, List<ARHitTestResult> hitTestResults) async {
    // Add note to anchor
    if (myPokemon == null) {
      var myPokemonNode = ARNode(
          type: NodeType.localGLTF2,
          uri:
          "assets/Chicken_01/Chicken_01.gltf",
          scale: Vector3(0.2, 0.2, 0.2),
          position: Vector3(0.0, 0.0, 0.0),
          rotation: Vector4(1.0, 0.0, 0.0, 0.0));

      bool? didAddNodeToAnchor =
      await arObjectManager.addNode(myPokemonNode, planeAnchor: newAnchor);
      if (didAddNodeToAnchor == true) {
        myPokemon = Pokemon(myPokemonNode, newAnchor);
        populateWorld(arObjectManager, arAnchorManager, hitTestResults);
        return true;
      } else {
        return false;
      }
    } else {
      myPokemon?.removeFromWorld(arObjectManager, arAnchorManager);
      myPokemon?.anchor = newAnchor;
      arObjectManager.addNode(myPokemon!.node, planeAnchor: newAnchor);
      return true;
    }
  }

  Future<void> clearWorldState(ARAnchorManager arAnchorManager, ARObjectManager arObjectManager) async {
    for (var pokemon in otherPokemons) {
      pokemon.removeFromWorld(arObjectManager, arAnchorManager);
    }

    myPokemon?.removeFromWorld(arObjectManager, arAnchorManager);

    myPokemon = null;
    otherPokemons = [];
  }
}