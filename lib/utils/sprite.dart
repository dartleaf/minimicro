import 'dart:math';
import 'dart:ui';

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
  Rect get localBounds {
    double scaleX = scale is List ? scale[0] : scale;
    double scaleY = scale is List ? scale[1] : scale;

    double width = image.width * scaleX;
    double height = image.height * scaleY;

    return Rect.fromLTWH(-width / 2, -height / 2, width, height);
  }

  /// Returns the bounds of the sprite in world coordinates
  Rect get worldBounds {
    Rect local = localBounds;
    return Rect.fromLTWH(
      x + local.left,
      y + local.top,
      local.width,
      local.height,
    );
  }

  /// Checks if a point is contained within the sprite's bounds
  bool contains(Offset point) {
    if (rotation == 0) {
      return worldBounds.contains(point);
    } else {
      // For rotated sprites, transform the point to local space
      double radians = rotation * (3.1415926535897932 / 180.0);
      double cosTheta = cos(-radians);
      double sinTheta = sin(-radians);

      double dx = point.dx - x;
      double dy = point.dy - y;

      double localX = dx * cosTheta - dy * sinTheta;
      double localY = dx * sinTheta + dy * cosTheta;

      return localBounds.contains(Offset(localX, localY));
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
