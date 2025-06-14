import 'package:flutter/material.dart';
import 'package:minimicro/shared_state/shared_state.dart';
import 'package:minimicro/widgets/display.dart';
import 'package:minimicro/widgets/tile_display.dart';

class TileDisplaySharedState extends SharedState {
  // Properties for the tile display
  int cols = 0;
  int rows = 0;
  List<List<int?>> _cells = [];
  List<List<Color?>> _cellTints = [];
  ImageProvider? tileSet;
  double? tileSetTileWidth;
  double? tileSetTileHeight;
  double? cellWidth;
  double? cellHeight;
  double overlapX = 0;
  double overlapY = 0;
  double oddRowOffset = 0;
  double oddColOffset = 0;
  double scrollX = 0;
  double scrollY = 0;

  void clear([int? toIndex]) {
    _cells = List.generate(rows, (r) => List.filled(cols, toIndex));
    _cellTints = List.generate(rows, (r) => List.filled(cols, null));
  }

  void setExtent(int cols, int rows) {
    cols = cols;
    rows = rows;
    clear();
  }

  get extent => [cols, rows];

  bool _isValidCell(int x, int y) {
    return x >= 0 && x < cols && y >= 0 && y < rows;
  }

  int? cell(int x, int y) {
    return setState(() {
      if (_isValidCell(x, y)) {
        return _cells[y][x];
      }
      return null;
    });
  }

  void setCell(int x, int y, int? idx) {
    if (_isValidCell(x, y)) {
      _cells[y][x] = idx;
      notifyListeners();
    }
  }

  Color? cellTint(int x, int y) {
    return setState(() {
      if (_isValidCell(x, y)) {
        return _cellTints[y][x];
      }
      return null;
    });
  }

  void setCellTint(int x, int y, Color? color) {
    if (_isValidCell(x, y)) {
      _cellTints[y][x] = color;
      notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TileDisplay(sharedState: this);
  }

  @override
  DisplayType get type => DisplayType.tile;
}
