import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:arcore_example/state/world_state.dart';
import 'package:flutter/material.dart';

class LocalAndWebObjectsView extends StatefulWidget {
  const LocalAndWebObjectsView({Key? key}) : super(key: key);

  @override
  State<LocalAndWebObjectsView> createState() => _LocalAndWebObjectsViewState();
}

class _LocalAndWebObjectsViewState extends State<LocalAndWebObjectsView> {

  late WorldState worldState;

  @override
  void dispose() {
    super.dispose();
    worldState.arSessionManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Object Transformation Gestures'),
        ),
        body: Stack(children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () => worldState.clearWorldState(),
                      child: const Text("Remove Everything")),
                ]),
          )
        ]));
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {

    worldState = WorldState(arSessionManager, arObjectManager, arAnchorManager, arLocationManager);

    worldState.arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "Images/triangle.png",
      showWorldOrigin: true,
      handlePans: true,
      handleRotation: true
    );
    worldState.arObjectManager.onInitialize();

    worldState.arSessionManager.onPlaneOrPointTap = onPlaneOrPointTapped;
    worldState.arObjectManager.onPanStart = onPanStarted;
    worldState.arObjectManager.onPanChange = onPanChanged;
    worldState.arObjectManager.onPanEnd = onPanEnded;
    worldState.arObjectManager.onRotationStart = onRotationStarted;
    worldState.arObjectManager.onRotationChange = onRotationChanged;
    worldState.arObjectManager.onRotationEnd = onRotationEnded;
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere(
            (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);

    var newAnchor =
    ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
    bool? didAddAnchor = await worldState.arAnchorManager.addAnchor(newAnchor);
    if (didAddAnchor == true) {
      bool? didAddNodeToAnchor = await worldState.iChoseYou(newAnchor, hitTestResults);
      if (didAddNodeToAnchor == false) {
        worldState.arSessionManager.onError("Adding Node to Anchor failed");
      }
    } else {
      worldState.arSessionManager.onError("Adding Anchor failed");
    }
  }

  onPanStarted(String nodeName) {
  }

  onPanChanged(String nodeName) {
  }

  onPanEnded(String nodeName, Matrix4 newTransform) {
    final pannedNode =
    worldState.otherPokemons.firstWhere((element) => element.node.name == nodeName);

    /*
    * Uncomment the following command if you want to keep the transformations of the Flutter representations of the nodes up to date
    * (e.g. if you intend to share the nodes through the cloud)
    */
    //pannedNode.transform = newTransform;
  }

  onRotationStarted(String nodeName) {

  }

  onRotationChanged(String nodeName) {

  }

  onRotationEnded(String nodeName, Matrix4 newTransform) {
    print("Ended rotating node " + nodeName);
    final rotatedNode =
    worldState.otherPokemons.firstWhere((element) => element.node.name == nodeName);

    /*
    * Uncomment the following command if you want to keep the transformations of the Flutter representations of the nodes up to date
    * (e.g. if you intend to share the nodes through the cloud)
    */
    //rotatedNode.transform = newTransform;
  }
}
