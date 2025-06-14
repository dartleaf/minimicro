import 'dart:math';

/// Represents a bounding box with position, size and rotation.
class Bounds {
  double x;
  double y;
  double width;
  double height;
  double rotation; // in degrees

  /// Creates a new Bounds object with the given parameters.
  Bounds({
    this.x = 0.0,
    this.y = 0.0,
    this.width = 0.0,
    this.height = 0.0,
    this.rotation = 0.0,
  });

  /// Returns the four corners of the bounding box as a list of [x, y] coordinates.
  List<Point> get corners {
    final double radians = rotation * pi / 180.0;
    final double cosTheta = cos(radians);
    final double sinTheta = sin(radians);

    final double halfWidth = width / 2;
    final double halfHeight = height / 2;

    return [
      _rotatePoint(-halfWidth, -halfHeight, cosTheta, sinTheta),
      _rotatePoint(halfWidth, -halfHeight, cosTheta, sinTheta),
      _rotatePoint(halfWidth, halfHeight, cosTheta, sinTheta),
      _rotatePoint(-halfWidth, halfHeight, cosTheta, sinTheta),
    ];
  }

  /// Helper method to rotate a point around the center.
  Point _rotatePoint(double dx, double dy, double cosTheta, double sinTheta) {
    final double rotatedX = dx * cosTheta - dy * sinTheta;
    final double rotatedY = dx * sinTheta + dy * cosTheta;
    return Point(x + rotatedX, y + rotatedY);
  }

  /// Checks if this bounding box overlaps with another bounding box.
  bool overlaps(Bounds b) {
    // For rotated boxes, check if any corner of one box is inside the other
    // or if any edges intersect
    if (rotation != 0.0 || b.rotation != 0.0) {
      final thisCorners = corners;
      final otherCorners = b.corners;

      // Check if any corner of either box is inside the other
      for (final corner in thisCorners) {
        if (b.contains(corner)) return true;
      }

      for (final corner in otherCorners) {
        if (contains(corner)) return true;
      }

      // Check for edge intersections
      for (int i = 0; i < 4; i++) {
        final p1 = thisCorners[i];
        final p2 = thisCorners[(i + 1) % 4];

        for (int j = 0; j < 4; j++) {
          final p3 = otherCorners[j];
          final p4 = otherCorners[(j + 1) % 4];

          if (_linesIntersect(p1, p2, p3, p4)) return true;
        }
      }

      return false;
    } else {
      // For axis-aligned boxes, use simpler check
      return !(x + width / 2 < b.x - b.width / 2 ||
          x - width / 2 > b.x + b.width / 2 ||
          y + height / 2 < b.y - b.height / 2 ||
          y - height / 2 > b.y + b.height / 2);
    }
  }

  /// Checks if a point is contained within this bounding box.
  bool contains(Point point) {
    final px = point.x;
    final py = point.y;
    if (rotation == 0.0) {
      // Simple case for non-rotated box
      return px >= x - width / 2 &&
          px <= x + width / 2 &&
          py >= y - height / 2 &&
          py <= y + height / 2;
    } else {
      // For rotated box, transform the point to the box's local coordinates
      final radians = -rotation * pi / 180.0;
      final cosTheta = cos(radians);
      final sinTheta = sin(radians);

      final dx = px - x;
      final dy = py - y;

      final localX = dx * cosTheta - dy * sinTheta;
      final localY = dx * sinTheta + dy * cosTheta;

      return localX >= -width / 2 &&
          localX <= width / 2 &&
          localY >= -height / 2 &&
          localY <= height / 2;
    }
  }

  /// Helper method to check if two line segments intersect.
  bool _linesIntersect(Point p1, Point p2, Point p3, Point p4) {
    final d1x = p2.x - p1.x;
    final d1y = p2.y - p1.y;
    final d2x = p4.x - p3.x;
    final d2y = p4.y - p3.y;

    final denominator = d1y * d2x - d1x * d2y;
    if (denominator == 0) return false; // Lines are parallel

    final d3x = p1.x - p3.x;
    final d3y = p1.y - p3.y;

    final t1 = (d3y * d2x - d3x * d2y) / denominator;
    final t2 = (d3y * d1x - d3x * d1y) / denominator;

    return t1 >= 0 && t1 <= 1 && t2 >= 0 && t2 <= 1;
  }
}
