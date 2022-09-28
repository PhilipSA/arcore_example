import 'dart:math';

import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:arcore_example/data/pokemon.dart';
import 'package:arcore_example/interactions/chase.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:vector_math/vector_math_64.dart';
import '../data/catmon.dart';
import '../interactions/dance.dart';

class WorldState extends ChangeNotifier {
  List<Pokemon> otherPokemons = [];
  Pokemon? myPokemon;

  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager arAnchorManager;
  late ARLocationManager arLocationManager;

  var assetPath = "cat_neutral.glb";

  WorldState(this.arSessionManager, this.arObjectManager, this.arAnchorManager,
      this.arLocationManager);

  Future<void> populateWorld(List<ARHitTestResult> hitTestResults) async {
    var positions = {
      Vector3(0.8, 0.0, 0.0),
      Vector3(0.0, 0.0, 0.8),
      Vector3(0.8, 0.0, 0.8),
    };

    for (var position in positions) {
      var myPokemonAnchorCopy = ARPlaneAnchor(
          transformation: myPokemon!.anchor.transformation);
      await arAnchorManager.addAnchor(myPokemonAnchorCopy);

      var otherPokemon = Catmon(arObjectManager, myPokemonAnchorCopy, position);
      otherPokemons.add(otherPokemon);
    }

    notifyListeners();
  }

  Future<bool> iChoseYou(ARPlaneAnchor newAnchor,
      List<ARHitTestResult> hitTestResults) async {
    if (myPokemon == null) {
      myPokemon = Catmon(arObjectManager, newAnchor, Vector3(0.0, 0.0, 0.0));
      populateWorld(hitTestResults);
      return true;
    } else {
      myPokemon?.removeFromWorld(arObjectManager, arAnchorManager);
      myPokemon?.anchor = newAnchor;
      arObjectManager.addNode(myPokemon!.node, planeAnchor: newAnchor);
      generateInteraction();
      return true;
    }
  }

  void generateInteraction() async {
    Pokemon? otherPokemonWithinDistance;

    for (var pokemon in otherPokemons) {
      var isWithinDistance = await arSessionManager.getDistanceBetweenAnchors(
          myPokemon!.anchor, pokemon.anchor);
      if (isWithinDistance != null ? isWithinDistance < 1.0 : false) {
        otherPokemonWithinDistance = pokemon;
      }
    }

    if (otherPokemonWithinDistance != null) {
      //var randomNumber = Random.secure().nextInt(1);
      var randomNumber = 0;

      if (randomNumber == 0) {
        var dance = Dance(myPokemon!, otherPokemonWithinDistance);
        dance.startDance(arObjectManager, arAnchorManager);
      }

      if (randomNumber == 1) {
        var chase = Chase(myPokemon!, otherPokemonWithinDistance);
        chase.startChase();
      }

/*      var battle = Battle(myPokemon!, otherPokemonWithinDistance);
      battle.startBattle();*/
    }
  }

  Future<void> clearWorldState() async {
    for (var pokemon in otherPokemons) {
      pokemon.removeFromWorld(arObjectManager, arAnchorManager);
    }

    myPokemon?.removeFromWorld(arObjectManager, arAnchorManager);

    myPokemon = null;
    otherPokemons = [];
  }
}