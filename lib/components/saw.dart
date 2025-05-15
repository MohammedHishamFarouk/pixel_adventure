import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Saw extends SpriteAnimationComponent
    with HasGameReference<PixelAdventure> {
  final bool isVertical;
  final double offNeg;
  final double offPos;
  Saw({
    this.isVertical = false,
    this.offNeg = 0,
    this.offPos = 0,
    position,
    size,
  }) : super(position: position, size: size);

  //this is the speed of the saw spinning animation
  static const double sawSpeed = 0.03;
  //this is our speed that the saw will move with in the range
  static const int moveSpeed = 50;
  static const int tileSize = 16;
  //this is our movement direction 1 is right and -1 is left
  double moveDirection = 1;
  //we will take our offPos and offNeg and multiply them by the tileSize
  //To get our movement range
  double rangeNeg = 0;
  double rangePos = 0;

  @override
  FutureOr<void> onLoad() {
    //this dictates the priority of the saw
    //the lower the number the further back the object is
    priority = -1;
    add(CircleHitbox());
    //we don't factor in the width or height of the saw into our calculations
    //since the saw will always go to a predefined spot
    //that we get from our range
    if (isVertical) {
      //we get the saw position and add or subtract
      //The offNeg and offPos multiplied by the tileSize
      //We multiply the tileSize to get the correct range
      //So since the tile is 16x16 , if we multiply it by 2 for example
      //the saw will move two squares
      rangeNeg = position.y - (offNeg * tileSize);
      rangePos = position.y + (offPos * tileSize);
    } else {
      rangeNeg = position.x - (offNeg * tileSize);
      rangePos = position.x + (offPos * tileSize);
    }

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Saw/On (38x38).png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: sawSpeed,
        textureSize: Vector2.all(38),
      ),
    );
    return super.onLoad();
  }

  @override
  update(double dt) {
    if (isVertical) {
      _moveVertically(dt);
    } else {
      _moveHorizontally(dt);
    }
    super.update(dt);
  }

  void _moveVertically(double dt) {
    if (position.y <= rangeNeg) {
      moveDirection = 1;
    } else if (position.y >= rangePos) {
      moveDirection = -1;
    }
    position.y += moveDirection * moveSpeed * dt;
  }

  void _moveHorizontally(double dt) {
    if (position.x <= rangeNeg) {
      moveDirection = 1;
    } else if (position.x >= rangePos) {
      moveDirection = -1;
    }
    position.x += moveDirection * moveSpeed * dt;
  }
}
