import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:minimicro/shared_state/pixel_display_shared_state.dart';

/// Utility class for drawing on a PixelDisplay.
/// Provides methods for drawing shapes, lines, text, and images.
/// Also includes methods for pixel manipulation and rendering the display as an image.
/// This class is designed to work with the PixelDisplaySharedState
/// which holds the pixel data and display properties
/// with the coordinate bottom-left is (0, 0).
class CanvasUtils {
  Canvas canvas;
  PixelDisplaySharedState sharedState;

  CanvasUtils(this.canvas, this.sharedState);

  double get width => sharedState.width;
  double get height => sharedState.height;
  Color get defaultColor => sharedState.defaultColor;
  double get scrollX => sharedState.scrollX;
  double get scrollY => sharedState.scrollY;
  double get scale => sharedState.scale;

  /// Clear the display with optional color, width, and height
  void clear([Color? clr, double? w, double? h]) {
    final color = clr ?? defaultColor;
    canvas.drawRect(
      Rect.fromLTWH(0, -height, w ?? width, h ?? height),
      Paint()..color = color,
    );
  }

  /// Get pixel color at coordinates
  Color pixel(int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) {
      return Colors.transparent;
    }

    final colorValue = sharedState.imageBytes.getUint32(
      (x + y * width.toInt()) * 4,
      Endian.little,
    );
    return Color(colorValue);
  }

  /// Set pixel color at coordinates
  void setPixel(double x, double y, Color? color) {
    canvas.drawRect(
      Rect.fromLTWH(x, -y - 1, 1, 1),
      Paint()..color = color ?? defaultColor,
    );
  }

  /// Draw a line between two points
  void line(
    double x1,
    double y1,
    double x2,
    double y2, [
    Color? color,
    double penSize = 1,
  ]) {
    final paint =
        Paint()
          ..color = color ?? defaultColor
          ..strokeWidth = penSize;

    canvas.drawLine(Offset(x1, -y1), Offset(x2, -y2), paint);
  }

  /// Draw rectangle outline
  void drawRect(
    double left,
    double bottom,
    double width,
    double height, [
    Color? color,
    double penSize = 1,
  ]) {
    final paint =
        Paint()
          ..color = color ?? defaultColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = penSize;

    canvas.drawRect(
      Rect.fromLTWH(left, -bottom - height, width, height),
      paint,
    );
  }

  /// Draw filled rectangle
  void fillRect(
    double left,
    double bottom,
    double width,
    double height, [
    Color? color,
  ]) {
    final paint =
        Paint()
          ..color = color ?? defaultColor
          ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(left, -bottom - height, width, height),
      paint,
    );
  }

  /// Draw ellipse outline
  void drawEllipse(
    double left,
    double bottom,
    double width,
    double height, [
    Color? color,
    double penSize = 1,
  ]) {
    final paint =
        Paint()
          ..color = color ?? defaultColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = penSize;

    canvas.drawOval(
      Rect.fromLTWH(left, -bottom - height, width, height),
      paint,
    );
  }

  /// Draw filled ellipse
  void fillEllipse(
    double left,
    double bottom,
    double width,
    double height, [
    Color? color,
  ]) {
    final paint =
        Paint()
          ..color = color ?? defaultColor
          ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromLTWH(left, -bottom - height, width, height),
      paint,
    );
  }

  /// Draw polygon outline
  void drawPoly(List<Offset> points, [Color? color, double penSize = 1]) {
    final paint =
        Paint()
          ..color = color ?? defaultColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = penSize;

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, -points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, -points[i].dy);
      }
      path.close();
    }
    canvas.drawPath(path, paint);
  }

  /// Draw filled polygon
  void fillPoly(List<Offset> points, [Color? color]) {
    final paint =
        Paint()
          ..color = color ?? defaultColor
          ..style = PaintingStyle.fill;

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, -points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, -points[i].dy);
      }
      path.close();
    }
    canvas.drawPath(path, paint);
  }

  Future<ui.Image> toImage([int? targetWidth, int? targetHeight]) async {
    return await sharedState.toImage(targetWidth, targetHeight);
  }

  /// Draw image or part of an image
  void drawImage(
    ui.Image img,
    double left,
    double bottom,
    double width,
    double height, [
    double? srcLeft,
    double? srcBottom,
    double? srcWidth,
    double? srcHeight,
  ]) {
    final srcRect = Rect.fromLTWH(
      srcLeft ?? 0,
      srcBottom ?? 0,
      srcWidth ?? img.width.toDouble(),
      srcHeight ?? img.height.toDouble(),
    );
    final dstRect = Rect.fromLTWH(left, -bottom - height, width, height);

    canvas.drawImageRect(img, srcRect, dstRect, Paint());
  }

  /// Get a portion of the display as an image
  Future<ui.Image> getImage(
    double left,
    double bottom,
    double width,
    double height,
  ) async {
    // Create a PictureRecorder and Canvas to capture the portion
    final recorder = ui.PictureRecorder();
    final captureCanvas = Canvas(recorder);

    // Define the source and destination rectangles
    final srcRect = Rect.fromLTWH(left, bottom, width, height);
    final dstRect = Rect.fromLTWH(0, 0, width, height);

    // Draw the selected portion to our new canvas
    captureCanvas.drawImageRect(await toImage(), srcRect, dstRect, Paint());

    // Convert to an image
    final picture = recorder.endRecording();
    return await picture.toImage(width.toInt(), height.toInt());
  }

  /// Print text to the display
  void print(
    String str,
    double x,
    double y, [
    Color? color,
    String font = "normal",
  ]) {
    final textColor = color ?? defaultColor;
    double fontSize;

    switch (font) {
      case "small":
        fontSize = 10;
        break;
      case "large":
        fontSize = 20;
        break;
      case "normal":
      default:
        fontSize = 14;
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: str,
        style: TextStyle(color: textColor, fontSize: fontSize),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset(x, -y - textPainter.height));
  }
}
