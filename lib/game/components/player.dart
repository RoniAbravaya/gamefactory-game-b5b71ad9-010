import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:testLast-platformer-10/game_objects/obstacle.dart';
import 'package:testLast-platformer-10/game_objects/collectable.dart';

/// The Player component for the platformer game.
class Player extends SpriteAnimationComponent with HasHitboxes, Collidable {
  static const double _playerSpeed = 200.0;
  static const double _playerJumpForce = 500.0;
  static const double _playerGravity = 1200.0;
  static const double _playerInvulnerabilityDuration = 1.0;

  double _velocityX = 0.0;
  double _velocityY = 0.0;
  double _health = 100.0;
  double _invulnerabilityTimer = 0.0;
  bool _isInvulnerable = false;

  /// Constructs a new Player instance.
  Player(Vector2 position) : super(position: position, size: Vector2(32, 48));

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load player sprite animation
    final spriteSheet = await Sprite.load('player.png');
    animation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.15,
        textureSize: Vector2(32, 48),
      ),
    );

    // Add hitboxes for collision detection
    addHitbox(HitboxRectangle(size: size));
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Handle player movement
    _handleMovement(dt);

    // Handle player invulnerability
    _handleInvulnerability(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    // Handle collisions with obstacles and collectibles
    if (other is Obstacle) {
      _handleObstacleCollision(other);
    } else if (other is Collectable) {
      _handleCollectableCollision(other);
    }
  }

  void _handleMovement(double dt) {
    // Apply gravity
    _velocityY += _playerGravity * dt;

    // Update player position
    position.add(Vector2(_velocityX * dt, _velocityY * dt));
  }

  void _handleInvulnerability(double dt) {
    if (_isInvulnerable) {
      _invulnerabilityTimer -= dt;
      if (_invulnerabilityTimer <= 0) {
        _isInvulnerable = false;
      }
    }
  }

  void _handleObstacleCollision(Obstacle obstacle) {
    // Handle player damage
    if (!_isInvulnerable) {
      _health -= 20;
      _isInvulnerable = true;
      _invulnerabilityTimer = _playerInvulnerabilityDuration;
    }

    // Resolve collision
    if (_velocityY > 0) {
      // Player is falling, so snap to the top of the obstacle
      position.y = obstacle.position.y - size.y;
      _velocityY = 0;
    } else {
      // Player is jumping, so bounce off the obstacle
      _velocityY = -_playerJumpForce;
    }
  }

  void _handleCollectableCollision(Collectable collectable) {
    // Handle collectable collection
    collectable.collect();
    // Add score, coins, or other effects
  }
}