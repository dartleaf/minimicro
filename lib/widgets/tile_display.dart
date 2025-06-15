import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:minimicro/constants.dart';
import 'package:minimicro/shared_state/tile_display_shared_state.dart';
import 'package:minimicro/widgets/display.dart';

class TileDisplay extends Display<TileDisplaySharedState> {
  const TileDisplay({super.key, required super.sharedState});

  @override
  Widget build(BuildContext context) {
    if (sharedState.tileSet == null ||
        sharedState.tileSetTileWidth == null ||
        sharedState.tileSetTileHeight == null ||
        sharedState.cellWidth == null ||
        sharedState.cellHeight == null ||
        sharedState.cols == 0 ||
        sharedState.rows == 0) {
      return SizedBox.shrink();
    }

    return SizedBox(
      width: displayWidth,
      height: displayHeight,
      child: ClipRect(
        child: CustomPaint(
          painter: TileGridPainter(sharedState: sharedState),
          size: Size(displayWidth, displayHeight),
        ),
      ),
    );
  }
}

class TileGridPainter extends CustomPainter {
  final TileDisplaySharedState sharedState;
  ui.Image? _tilesetImage;

  TileGridPainter({required this.sharedState}) : super(repaint: sharedState) {
    _loadTilesetImage();
  }

  Future<ui.Image> _loadTilesetImage() async {
    final completer = Completer<ui.Image>();
    final ImageStream stream = sharedState.tileSet!.resolve(
      ImageConfiguration.empty,
    );

    final listener = ImageStreamListener((info, _) {
      _tilesetImage = info.image;
      completer.complete(info.image);
    });

    stream.addListener(listener);
    return completer.future;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_tilesetImage == null) return;

    final paint = Paint()..filterQuality = FilterQuality.low;
    final tintPaint = Paint()..blendMode = BlendMode.srcATop;

    // Calculate tiles per row in the tileset
    final tilesPerRow =
        (_tilesetImage!.width / sharedState.tileSetTileWidth!).floor();

    for (int y = 0; y < sharedState.rows; y++) {
      for (int x = 0; x < sharedState.cols; x++) {
        final index = sharedState.cell(x, y);
        if (index == null) continue; // Skip empty cells

        // Calculate position with offsets, overlap, and scroll
        double posX =
            x * (sharedState.cellWidth! - sharedState.overlapX) -
            sharedState.scrollX;
        double posY =
            y * (sharedState.cellHeight! - sharedState.overlapY) -
            sharedState.scrollY;

        // Apply odd row/column offsets
        if (y % 2 == 1) posX += sharedState.oddRowOffset;
        if (x % 2 == 1) posY += sharedState.oddColOffset;

        // Calculate tile position in tileset
        final tileRow = index ~/ tilesPerRow;
        final tileCol = index % tilesPerRow;

        // Source rectangle is the specific tile in the tileset
        final srcRect = Rect.fromLTWH(
          tileCol * sharedState.tileSetTileWidth!,
          tileRow * sharedState.tileSetTileHeight!,
          sharedState.tileSetTileWidth!,
          sharedState.tileSetTileHeight!,
        );

        // Destination rectangle is where we want to draw this tile
        final dstRect = Rect.fromLTWH(
          posX,
          posY,
          sharedState.cellWidth!,
          sharedState.cellHeight!,
        );

        // Draw the tile
        canvas.drawImageRect(_tilesetImage!, srcRect, dstRect, paint);

        // Apply tint if specified
        final tint = sharedState.cellTint(x, y);
        if (tint != null) {
          tintPaint.color = tint.withAlpha((0.5 * 256).toInt());
          canvas.drawRect(dstRect, tintPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant TileGridPainter oldDelegate) {
    return oldDelegate.sharedState != sharedState ||
        oldDelegate._tilesetImage != _tilesetImage;
  }
}
