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
