import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:minimicro/constants.dart';
import 'package:minimicro/shared_state/shared_state.dart';
import 'package:minimicro/widgets/display.dart';
import 'package:minimicro/widgets/pixel_display.dart';

class PixelDisplaySharedState extends SharedState {
  @override
  final DisplayType type = DisplayType.pixel;

  ByteData imageBytes = ByteData((displayWidth * displayHeight * 4).toInt());

  double scrollX = 0;
  double scrollY = 0;
  double scale = 1.0;
  Color defaultColor = Colors.black;
  double get width => displayWidth;
  double get height => displayHeight;

  Future<ui.Image> toUiImage([int? targetWidth, int? targetHeight]) async {
    final codec = await ui.instantiateImageCodec(
      imageBytes.buffer.asUint8List(),
      targetWidth: targetWidth,
      targetHeight: targetHeight,
      allowUpscaling: true,
    );
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  Future<void> render(
    Future<void> Function(Canvas canvas, PixelDisplaySharedState sharedState)
    callback,
  ) async {
    await setState(() async {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      canvas.drawImageRect(
        await toUiImage(),
        Rect.fromLTWH(0, 0, displayWidth, displayHeight),
        Rect.fromLTWH(0, 0, displayWidth, displayHeight),
        Paint(),
      );
      canvas.save();
      canvas.scale(1, -1);
      canvas.translate(scrollX, scrollY);
      canvas.scale(scale);
      await callback(canvas, this);
      canvas.restore();

      final picture = recorder.endRecording();
      final img = await picture.toImage(
        displayWidth.toInt(),
        displayHeight.toInt(),
      );

      imageBytes = (await img.toByteData(format: ui.ImageByteFormat.png))!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PixelDisplay(sharedState: this);
  }
}
