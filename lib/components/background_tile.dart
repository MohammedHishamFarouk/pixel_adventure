import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

//old way of moving the background

class BackgroundTile extends SpriteComponent
    with HasGameReference<PixelAdventure> {
  final String color;
  BackgroundTile({position, this.color = 'Gray'}) : super(position: position);
  final double scrollSpeed = 0.4;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    size = Vector2.all(64.6);
    sprite = Sprite(game.images.fromCache('Background/$color.png'));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y += scrollSpeed;
    double tileSize = 64;
    int scrollHeight = (game.size.y / tileSize).floor();
    if (position.y > scrollHeight * tileSize) position.y = -tileSize;
    super.update(dt);
  }
}
