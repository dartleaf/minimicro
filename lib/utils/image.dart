import 'dart:ui' as ui show Image, PictureRecorder, ImageByteFormat;

import 'package:flutter/material.dart';

class Image {
  final int width;
  final int height;
  final List<List<Color>> pixels;
  final ui.Image? uiImage;

  Image(this.width, this.height, this.pixels, [this.uiImage]);

  factory Image.create(int width, int height, Color initialColor) {
    final pixels = List.generate(
      height,
      (_) => List.filled(width, initialColor),
    );
    return Image(width, height, pixels);
  }

  static Future<Image> fromUiImage(ui.Image uiImage) async {
    final width = uiImage.width;
    final height = uiImage.height;
    final pixelData = await uiImage.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    final pixels = List<List<Color>>.generate(
      height,
      (_) => List<Color>.filled(width, Colors.transparent),
    );

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final offset = (y * width + x) * 4;
        final r = pixelData!.getUint8(offset);
        final g = pixelData.getUint8(offset + 1);
        final b = pixelData.getUint8(offset + 2);
        final a = pixelData.getUint8(offset + 3);
        pixels[y][x] = Color.fromARGB(a, r, g, b);
      }
    }
    return Image(width, height, pixels, uiImage);
  }

  /// Get pixel color at (x,y)
  Color pixel(int x, int y) {
    return pixels[y][x];
  }

  /// Set pixel color at (x,y)
  void setPixel(int x, int y, Color color) {
    pixels[y][x] = color;
  }

  /// Get a sub-image
  Image getImage(int left, int bottom, int width, int height) {
    final newPixels = List.generate(
      height,
      (y) => List.generate(width, (x) => pixel(left + x, bottom + y)),
    );

    return Image(width, height, newPixels);
  }

  /// Convert to Flutter's Image widget (for display)
  Widget toImageWidget() {
    return CustomPaint(
      painter: _ImagePainter(this),
      size: Size(width.toDouble(), height.toDouble()),
    );
  }

  Future<ui.Image> toUiImage() {
    if (uiImage != null) {
      return Future.value(uiImage);
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(
        Offset(0, 0),
        Offset(width.toDouble(), height.toDouble()),
      ),
    );

    final paint = Paint();

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        paint.color = pixel(x, y);
        canvas.drawRect(Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1), paint);
      }
    }

    final picture = recorder.endRecording();
    return picture.toImage(width, height);
  }
}

class _ImagePainter extends CustomPainter {
  final Image image;

  _ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        paint.color = image.pixel(x, y);
        canvas.drawRect(Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
