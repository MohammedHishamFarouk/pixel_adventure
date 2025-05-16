import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum FlagStates { noFlag, flagOut, flagIdle }

class Checkpoint extends SpriteAnimationGroupComponent
    with HasGameReference<PixelAdventure>, CollisionCallbacks {
  Checkpoint({position, size}) : super(position: position, size: size);
  bool reachedCheckpoint = false;

  late SpriteAnimation noFlagAnimation;
  late SpriteAnimation flagOutAnimation;
  late SpriteAnimation flagIdleAnimation;

  @override
  FutureOr<void> onLoad() {
    //these numbers you get by trying
    //the tutorial never specified how he got them maybe there are better numbers
    add(
      RectangleHitbox(
        position: Vector2(18, 56),
        size: Vector2(12, 8),
        collisionType: CollisionType.passive,
      ),
    );
    noFlagAnimation = _spriteAnimation('(No Flag)', 1, 1);
    flagOutAnimation = _spriteAnimation('(Flag Out) (64x64)', 26, 0.05);
    flagIdleAnimation = _spriteAnimation('(Flag Idle)(64x64)', 10, 0.05);
    animations = {
      FlagStates.noFlag: noFlagAnimation,
      FlagStates.flagOut: flagOutAnimation,
      FlagStates.flagIdle: flagIdleAnimation,
    };
    current = FlagStates.noFlag;
    return super.onLoad();
  }

  SpriteAnimation _spriteAnimation(String state, int amount, double stepTime) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(
        'Items/Checkpoints/Checkpoint/Checkpoint $state.png',
      ),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(64),
        loop: false,
      ),
    );
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is Player && !reachedCheckpoint) _reachedCheckpoint();
    super.onCollisionStart(intersectionPoints, other);
  }

  void _reachedCheckpoint() {
    reachedCheckpoint = true;
    current = FlagStates.flagOut;
    final flagOutAnimation = animationTickers![FlagStates.flagOut];
    flagOutAnimation!.completed.whenComplete(() {
      current = FlagStates.flagIdle;
      final flagIdleAnimation = animationTickers![FlagStates.flagIdle];
      flagIdleAnimation!.completed.whenComplete(() {
        //switch level
        game.loadNextLevel();
      });
    });
  }
}
