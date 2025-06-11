import 'package:flutter/material.dart';
import 'package:minimicro/shared_state/shared_state.dart';
import 'package:minimicro/widgets/display.dart';
import 'package:minimicro/widgets/pixel_display.dart';

class PixelDisplaySharedState extends SharedState {
  @override
  final DisplayType type = DisplayType.pixel;

  @override
  Widget build(BuildContext context) {
    return PixelDisplay(sharedState: this);
  }
}
