import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:testLast-platformer-10/components/player.dart';
import 'package:testLast-platformer-10/components/obstacle.dart';
import 'package:testLast-platformer-10/components/collectible.dart';
import 'package:testLast-platformer-10/services/analytics.dart';
import 'package:testLast-platformer-10/services/ads.dart';
import 'package:testLast-platformer-10/services/storage.dart';

/// The main game class for the 'testLast-platformer-10' game.
///
/// This class extends [FlameGame] and manages the game state, level loading,
/// score tracking, and integration with various services.
class testLast-platformer-10Game extends FlameGame with TapDetector {
  /// The current game state.
  GameState _gameState = GameState.playing;

  /// The player component.
  late Player _player;

  /// The list of obstacles in the current level.
  final List<Obstacle> _obstacles = [];

  /// The list of collectibles in the current level.
  final List<Collectible> _collectibles = [];

  /// The current score.
  int _score = 0;

  /// The analytics service.
  final AnalyticsService _analyticsService = AnalyticsService();

  /// The ads service.
  final AdsService _adsService = AdsService();

  /// The storage service.
  final StorageService _storageService = StorageService();

  @override
  Future<void> onLoad() async {
    // Load the first level
    await _loadLevel(1);
  }

  /// Loads the specified level.
  Future<void> _loadLevel(int levelNumber) async {
    // Load level data from storage or other source
    // Create player, obstacles, and collectibles
    _player = Player();
    _obstacles.addAll(await _loadObstacles(levelNumber));
    _collectibles.addAll(await _loadCollectibles(levelNumber));

    // Add components to the game world
    add(_player);
    _obstacles.forEach(add);
    _collectibles.forEach(add);

    // Reset the score
    _score = 0;

    // Notify analytics about the level start
    _analyticsService.logLevelStart(levelNumber);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update game state based on player and component interactions
    switch (_gameState) {
      case GameState.playing:
        // Update player, obstacles, and collectibles
        _player.update(dt);
        _obstacles.forEach((obstacle) => obstacle.update(dt));
        _collectibles.forEach((collectible) => collectible.update(dt));

        // Check for collisions and update score
        _handleCollisions();
        break;
      case GameState.paused:
        // Pause game logic
        break;
      case GameState.gameOver:
        // Handle game over logic
        break;
      case GameState.levelComplete:
        // Handle level complete logic
        break;
    }
  }

  /// Handles collisions between the player, obstacles, and collectibles.
  void _handleCollisions() {
    // Check for player collisions with obstacles and collectibles
    // Update score and game state accordingly
    // Notify analytics about level completion or failure
  }

  @override
  void onTapDown(TapDownInfo info) {
    // Handle tap input for the player's jump action
    _player.jump();
  }

  /// Pauses the game.
  void pauseGame() {
    _gameState = GameState.paused;
  }

  /// Resumes the game.
  void resumeGame() {
    _gameState = GameState.playing;
  }

  /// Ends the game.
  void gameOver() {
    _gameState = GameState.gameOver;
    // Notify analytics about the game over event
    _analyticsService.logGameOver();
  }

  /// Completes the current level.
  void levelComplete() {
    _gameState = GameState.levelComplete;
    // Notify analytics about the level completion event
    _analyticsService.logLevelComplete(_score);
    // Save the player's progress
    _storageService.savePlayerProgress();
  }
}

/// Represents the different game states.
enum GameState {
  playing,
  paused,
  gameOver,
  levelComplete,
}