import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/actors/player.dart';

class Level extends World {
  final String levelName;
  Level({required this.levelName});
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    //loads the level file that we created
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);
    //we get the spawnPoint layer that we created
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    //we loop through all the spawnPoints and add objects based on the spawnPoint class
    for (final spawnPoint in spawnPointLayer!.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          final player = Player(
            character: 'Mask Dude',
            position: Vector2(spawnPoint.x, spawnPoint.y),
          );
          add(player);
          break;
        default:
      }
    }

    return super.onLoad();
  }
}
