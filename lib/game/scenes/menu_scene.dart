import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

/// The main menu scene for the platformer game.
class MenuScene extends Component with TapCallbacks {
  /// The title of the game.
  final String gameTitle;

  /// The tagline of the game.
  final String gameTagline;

  /// The play button.
  late final ButtonComponent playButton;

  /// The level select button.
  late final ButtonComponent levelSelectButton;

  /// The settings button.
  late final ButtonComponent settingsButton;

  /// The background animation.
  late final SpriteAnimationComponent backgroundAnimation;

  /// Creates a new instance of the [MenuScene] class.
  MenuScene({
    required this.gameTitle,
    required this.gameTagline,
  }) {
    _createPlayButton();
    _createLevelSelectButton();
    _createSettingsButton();
    _createBackgroundAnimation();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(backgroundAnimation);
    add(playButton);
    add(levelSelectButton);
    add(settingsButton);
  }

  void _createPlayButton() {
    playButton = ButtonComponent(
      position: Vector2(size.x / 2, size.y * 0.6),
      size: Vector2(200, 60),
      onPressed: () {
        // Navigate to the game scene
      },
      child: TextComponent(
        text: 'Play',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }

  void _createLevelSelectButton() {
    levelSelectButton = ButtonComponent(
      position: Vector2(size.x / 2, size.y * 0.7),
      size: Vector2(200, 60),
      onPressed: () {
        // Navigate to the level select scene
      },
      child: TextComponent(
        text: 'Level Select',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }

  void _createSettingsButton() {
    settingsButton = ButtonComponent(
      position: Vector2(size.x / 2, size.y * 0.8),
      size: Vector2(200, 60),
      onPressed: () {
        // Navigate to the settings scene
      },
      child: TextComponent(
        text: 'Settings',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }

  void _createBackgroundAnimation() {
    backgroundAnimation = SpriteAnimationComponent(
      animation: SpriteAnimation.spriteList([
        // Add your background sprites here
      ], stepTime: 0.1),
      position: Vector2.zero(),
      size: size,
    );
  }
}