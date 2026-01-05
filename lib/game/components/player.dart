import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';

/// The player character in the platformer game.
class Player extends SpriteAnimationComponent
    with HasGameRef, Collidable, TapCallbacks {
  /// The player's current horizontal speed.
  double xSpeed = 200;

  /// The player's current vertical speed.
  double ySpeed = 0;

  /// The player's maximum jump height.
  double maxJumpHeight = 300;

  /// The player's current health.
  int health = 3;

  /// The player's current score.
  int score = 0;

  /// The player's animation states.
  late SpriteAnimation idleAnimation;
  late SpriteAnimation runningAnimation;
  late SpriteAnimation jumpingAnimation;

  /// Initializes the player component.
  Player(Vector2 position) : super(position: position, size: Vector2.all(50));

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load the player's animation sprites
    final spriteSheet = await gameRef.loadSpriteSheet(
      'player.png',
      srcSize: Vector2.all(50),
    );

    idleAnimation = spriteSheet.createAnimation(row: 0, cols: 4, stepTime: 0.2);
    runningAnimation = spriteSheet.createAnimation(row: 1, cols: 6, stepTime: 0.1);
    jumpingAnimation = spriteSheet.createAnimation(row: 2, cols: 2, stepTime: 0.5);

    animation = idleAnimation;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the player's position based on speed
    position.x += xSpeed * dt;
    position.y += ySpeed * dt;

    // Update the player's animation based on movement
    if (xSpeed != 0) {
      animation = runningAnimation;
    } else {
      animation = idleAnimation;
    }

    // Apply gravity
    ySpeed += 1000 * dt;

    // Clamp the player's position to the game world
    position.clamp(
      Vector2.zero() + size / 2,
      gameRef.size - size / 2,
    );
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);

    // Jump when the player taps the screen
    if (ySpeed == 0) {
      ySpeed = -maxJumpHeight;
      animation = jumpingAnimation;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    // Handle collisions with other objects
    if (other is Obstacle) {
      // Reduce the player's health on collision with an obstacle
      health--;
    }
  }
}