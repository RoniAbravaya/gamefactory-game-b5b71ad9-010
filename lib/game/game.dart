import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:testLast-platformer-10/analytics_service.dart';
import 'package:testLast-platformer-10/game_controller.dart';
import 'package:testLast-platformer-10/level_config.dart';
import 'package:testLast-platformer-10/player.dart';

/// The main FlameGame subclass for the testLast-platformer-10 game.
class testLast_platformer_10Game extends FlameGame with TapDetector {
  /// The current game state.
  GameState gameState = GameState.playing;

  /// The player character.
  late Player player;

  /// The game controller.
  late GameController gameController;

  /// The analytics service.
  late AnalyticsService analyticsService;

  /// The current level configuration.
  late LevelConfig levelConfig;

  /// The player's score.
  int score = 0;

  /// The player's remaining lives.
  int lives = 3;

  @override
  Future<void> onLoad() async {
    // Set up the camera and world
    camera.viewport = FixedResolutionViewport(Vector2(720, 1280));
    camera.followComponent(player);

    // Load the level configuration
    levelConfig = await LevelConfig.load('level1.json');

    // Initialize the player
    player = Player(levelConfig.playerStartPosition);
    add(player);

    // Initialize the game controller
    gameController = GameController(this);
    add(gameController);

    // Initialize the analytics service
    analyticsService = AnalyticsService();
  }

  @override
  void onTapDown(TapDownInfo info) {
    // Handle player input
    gameController.handleTap(info.eventPosition.game);
  }

  /// Update the game state and handle collisions.
  @override
  void update(double dt) {
    super.update(dt);

    // Update the game state
    switch (gameState) {
      case GameState.playing:
        // Handle player and enemy collisions
        _handleCollisions();
        break;
      case GameState.paused:
        // Pause the game
        break;
      case GameState.gameOver:
        // Handle game over
        break;
      case GameState.levelComplete:
        // Handle level completion
        break;
    }

    // Update the score and lives
    _updateScoreAndLives();
  }

  /// Handle collisions between the player and other game objects.
  void _handleCollisions() {
    // Detect collisions and update the game state accordingly
    if (player.isCollidingWithEnemy()) {
      // Player has collided with an enemy
      _handlePlayerDeath();
    } else if (player.hasReachedGoal()) {
      // Player has reached the goal
      _handleLevelComplete();
    }
  }

  /// Handle the player's death.
  void _handlePlayerDeath() {
    // Reduce the player's lives
    lives--;

    if (lives <= 0) {
      // Game over
      gameState = GameState.gameOver;
      analyticsService.logGameOver();
    } else {
      // Restart the level
      gameState = GameState.playing;
      player.reset();
    }
  }

  /// Handle the completion of a level.
  void _handleLevelComplete() {
    // Update the score
    score += levelConfig.scoreForCompletion;

    // Unlock the next level (if applicable)
    if (levelConfig.isLastLevel()) {
      gameState = GameState.levelComplete;
      analyticsService.logLevelComplete();
    } else {
      // Load the next level
      levelConfig = await LevelConfig.load('level2.json');
      player.reset();
      gameState = GameState.playing;
    }
  }

  /// Update the player's score and lives.
  void _updateScoreAndLives() {
    // Update the score and lives UI elements
  }
}

/// The possible game states.
enum GameState {
  playing,
  paused,
  gameOver,
  levelComplete,
}