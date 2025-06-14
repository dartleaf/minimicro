import 'package:flutter/material.dart';
import 'package:minimicro/shared_state/shared_state.dart';
import 'package:minimicro/utils/sprite.dart';
import 'package:minimicro/widgets/display.dart';
import 'package:minimicro/widgets/sprite_display.dart';

/// A shared state that manages the display of a sprite.
class SpriteDisplaySharedState extends SharedState {
  /// The list of sprites to be drawn, with index 0 at the back
  final List<Sprite> sprites = [];

  /// Horizontal scroll offset for all sprites
  double scrollX = 0;

  /// Vertical scroll offset for all sprites
  double scrollY = 0;

  /// Clears all sprites from the display
  void clear() {
    sprites.clear();
    notifyListeners();
  }

  /// Adds a sprite to the display
  void addSprite(Sprite sprite) {
    sprites.add(sprite);
    notifyListeners();
  }

  /// Updates the scroll position
  void setScroll(double x, double y) {
    scrollX = x;
    scrollY = y;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return SpriteDisplay(sharedState: this);
  }

  @override
  DisplayType get type => DisplayType.sprite;
}
