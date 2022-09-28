import 'package:vector_math/vector_math_64.dart';
import 'base_interaction.dart';

class Battle extends BaseInteraction {
  Battle(super.firstPokemon, super.secondPokemon);

  void startBattle() {
    _rotateToFaceEachOther();
  }

  void _rotateToFaceEachOther() {

    var forward = firstPokemon.node.position - secondPokemon.node.position;
    forward.normalize();
    var up = Vector3(0, 1.0, 0);
    var tangent0 = Vector3(0, 0, 0);
    cross3(forward, up, tangent0);
    if (tangent0.length < 0.001)
    {
      up = Vector3(1.0, 0, 0);
      cross3(forward, up, tangent0);
    }
    tangent0.normalize();
    cross3(forward, tangent0, up);

    var rotation = Matrix3(
        forward.x, up.x, tangent0.x,
        forward.y, up.y, tangent0.y,
        forward.z, up.z, tangent0.z
    );

    firstPokemon.node.rotation = rotation;
  }

  void _movePokemonsForward(double step) {

  }
}