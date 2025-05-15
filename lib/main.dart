import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //we make sure that the game runs in landscape and fullscreen before creating it
  //since without the await the game is created before the device is set
  // which leads to a misplacement of the joystick
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  PixelAdventure game = PixelAdventure();
  runApp(GameWidget(game: kDebugMode ? PixelAdventure() : game));
}

// whenever you make a game or copy a game and you need to do something or encounter a problem
// think of what you want to do and how it should be done
// try to break it into smaller steps to try to get to the final result in your head
// so you can ask your self:
// what is going to happen
// why is it happening
// when will it happen
