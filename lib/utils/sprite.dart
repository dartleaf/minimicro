import 'dart:math';
import 'dart:ui';

import 'package:minimicro/utils/bounds.dart';

/// A simple sprite class that represents a 2D image with position, scale, rotation, and tint.
/// It provides methods to get the local and world bounds, check if a point is contained within the sprite,
/// and check for overlaps with another sprite.
/// The coordinate system is bottom-left, meaning (0, 0) is at the bottom-left corner of the sprite.
class Sprite {
  Image image;
  double x = 0.0;
  double y = 0.0;
  dynamic scale = 1.0;
  double rotation = 0.0;
  Color tint = const Color(0xFFFFFFFF); // white for no tint

  Sprite({
    required this.image,
    this.x = 0.0,
    this.y = 0.0,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.tint = const Color(0xFFFFFFFF),
  });

  /// Returns the bounds of the sprite relative to its position
  Bounds get localBounds {
    double scaleX = scale is List ? scale[0] : scale;
    double scaleY = scale is List ? scale[1] : scale;

    double width = image.width * scaleX;
    double height = image.height * scaleY;

    return Bounds(x: -width / 2, y: -height / 2, width: width, height: height);
  }

  /// Returns the bounds of the sprite in world coordinates
  Bounds get worldBounds {
    final local = localBounds;
    return Bounds(
      x: x + local.x,
      y: y + local.y,
      width: local.width,
      height: local.height,
      rotation: rotation,
    );
  }

  /// Checks if a point is contained within the sprite's bounds
  bool contains(Point point) {
    if (rotation == 0) {
      return worldBounds.contains(point);
    } else {
      // For rotated sprites, transform the point to local space
      double radians = rotation * (3.1415926535897932 / 180.0);
      double cosTheta = cos(-radians);
      double sinTheta = sin(-radians);

      double dx = point.x - x;
      double dy = point.y - y;

      double localX = dx * cosTheta - dy * sinTheta;
      double localY = dx * sinTheta + dy * cosTheta;

      return localBounds.contains(Point(localX, localY));
    }
  }

  /// Checks if this sprite overlaps with another sprite
  bool overlaps(Sprite other) {
    // Simple AABB collision check for non-rotated sprites
    if (rotation == 0 && other.rotation == 0) {
      return worldBounds.overlaps(other.worldBounds);
    } else {
      // More complex check would be needed for rotated sprites
      // This is a simplified approximation
      return worldBounds.overlaps(other.worldBounds);
    }
  }
}

extension RectExtension on Rect {
  bool overlaps(Rect other) {
    return !(right < other.left ||
        left > other.right ||
        bottom < other.top ||
        top > other.bottom);
  }
}
