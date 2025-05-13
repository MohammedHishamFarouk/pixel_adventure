import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum PlayerState { idle, running }

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure> {
  final String character;
  Player({position, required this.character}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  final double stepTime = 0.05;

  PlayerDirection playerDirection = PlayerDirection.none;
  final double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updatePlayerMovement(dt);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runAnimation = _spriteAnimation('Run', 12);
    //list of all the animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runAnimation,
    };
    //set the current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void _updatePlayerMovement(double dt) {
    double dirX = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        dirX -= moveSpeed;
        current = PlayerState.running;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        dirX += moveSpeed;
        current = PlayerState.running;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
      default:
        break;
    }
    velocity = Vector2(dirX, 0.0);
    position += velocity * dt;
  }
}
