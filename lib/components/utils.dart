bool checkCollision(player, block) {
  final hitbox = player.hitbox;
  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixedX =
      player.scale.x < 0
          ? playerX - (hitbox.offsetX * 2) - playerWidth
          : playerX;
  final fixedY = block.isPlatform ? playerY + playerHeight : playerY;
  return (
  //if the left side of the player is intersecting the right side of the block
  // we are colliding
  fixedX < blockX + blockWidth &&
      //if the right side of the player is intersecting the left side of the block
      // we are colliding
      fixedX + playerWidth > blockX &&
      //if the top of the player is intersecting the bottom of the block we are colliding
      fixedY < blockY + blockHeight &&
      //if the bottom of the player is intersecting the top of the block we are colliding
      playerY + playerHeight > blockY);
}
