import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

/// A collectible item component for a platformer game.
class Collectible extends SpriteComponent with HasGameRef {
  /// The score value of the collectible.
  final int scoreValue;

  /// The audio player for the collection sound effect.
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// The sprite animation for the collectible.
  late final SpriteAnimation _animation;

  /// Creates a new instance of the [Collectible] component.
  ///
  /// [position]: The initial position of the collectible.
  /// [size]: The size of the collectible.
  /// [scoreValue]: The score value of the collectible.
  Collectible({
    required Vector2 position,
    required Vector2 size,
    required this.scoreValue,
  }) : super(position: position, size: size) {
    _setupAnimation();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAudio();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updateAnimation(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _animation.getSprite().render(canvas, position: size / 2, size: size);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    _collectItem();
  }

  /// Loads the audio file for the collection sound effect.
  Future<void> _loadAudio() async {
    await _audioPlayer.setAsset('assets/sounds/collect_item.mp3');
  }

  /// Sets up the sprite animation for the collectible.
  void _setupAnimation() {
    final spriteSheet = SpriteSheet(
      image: Image.asset('assets/images/collectible.png'),
      srcSize: Vector2(32, 32),
    );

    _animation = spriteSheet.createAnimation(row: 0, stepTime: 0.2, to: 4);
  }

  /// Updates the sprite animation for the collectible.
  void _updateAnimation(double dt) {
    _animation.update(dt);
  }

  /// Handles the collection of the item, including playing the sound effect and
  /// triggering the score update.
  void _collectItem() {
    _audioPlayer.play();
    gameRef.score += scoreValue;
    removeFromParent();
  }
}