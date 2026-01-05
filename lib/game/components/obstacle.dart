import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:testLast-platformer-10/player.dart';

/// An obstacle component for the platformer game.
class Obstacle extends PositionComponent with CollisionCallbacks, HasGameRef {
  final Sprite _sprite;
  final double _speed;
  final double _damage;

  /// Creates a new instance of the [Obstacle] component.
  ///
  /// [sprite]: The sprite to be used for the obstacle.
  /// [speed]: The speed at which the obstacle moves.
  /// [damage]: The amount of damage the obstacle deals to the player on collision.
  Obstacle({
    required Sprite sprite,
    required double speed,
    required double damage,
  })  : _sprite = sprite,
        _speed = speed,
        _damage = damage {
    size = Vector2.all(50.0);
    anchor = Anchor.center;
    addShape(HitboxShape.rectangle(size: size));
  }

  @override
  void onMount() {
    super.onMount();
    position = Vector2(gameSize.x + width / 2, gameSize.y - height / 2);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= _speed * dt;

    if (position.x + width / 2 < 0) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _sprite.render(canvas, position: position, size: size);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      other.takeDamage(_damage);
    }
  }
}