import 'dart:ui' as ui;

class Color extends ui.Color {
  /// Creates a color from RGB values (0-255)
  const Color.rgb(int r, int g, int b)
    : super(0xFF000000 | ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | (b & 0xFF));

  /// Creates a color from RGBA values (0-255)
  const Color.rgba(int r, int g, int b, int a)
    : super(
        ((a & 0xFF) << 24) |
            ((r & 0xFF) << 16) |
            ((g & 0xFF) << 8) |
            (b & 0xFF),
      );

  /// Linearly interpolate between two colors
  static Color lerp(Color c1, Color c2, double t) {
    return Color.rgba(
      _lerpInt(toInt(c1.r), toInt(c2.r), t),
      _lerpInt(toInt(c1.g), toInt(c2.g), t),
      _lerpInt(toInt(c1.b), toInt(c2.b), t),
      _lerpInt(toInt(c1.a), toInt(c2.a), t),
    );
  }

  static int toInt(double v) {
    return (v * 255).toInt();
  }

  /// Convert a color to [r, g, b, a] list
  static List<int> toList(Color c) {
    return [toInt(c.r), toInt(c.g), toInt(c.b), toInt(c.a)];
  }

  /// Create a color from [r, g, b, a] list
  static Color fromList(List<int> lst) {
    if (lst.length < 3) {
      throw ArgumentError('List must have at least 3 elements');
    }
    return Color.rgba(lst[0], lst[1], lst[2], lst.length > 3 ? lst[3] : 255);
  }

  // Helper for lerp
  static int _lerpInt(int a, int b, double t) {
    return (a + (b - a) * t).round().clamp(0, 255);
  }
}
