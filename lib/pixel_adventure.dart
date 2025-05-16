import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/level.dart';
import 'package:pixel_adventure/components/player.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF211f30);

  late CameraComponent cam;
  late JoystickComponent joystick;
  Player player = Player(character: "Mask Dude");
  bool showJoystick = false;
  List<String> levelNames = ['level-01', 'level-01'];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    // loads all images into cache
    await images.loadAllImages();
    _loadLevel();
    if (showJoystick) addJoyStick();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) updateJoyStick();
    super.update(dt);
  }

  void addJoyStick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(sprite: Sprite(images.fromCache('HUD/Knob.png'))),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/joystick.png')),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    cam.viewport.add(joystick);
  }

  void updateJoyStick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }

  void loadNextLevel() async {
    removeWhere((component) => component is Level);
    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      //game over
    }
  }

  void _loadLevel() {
    Level world = Level(
      levelName: levelNames[currentLevelIndex],
      player: player,
    );

    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 640,
      height: 360,
    );
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);
  }
}
