import 'package:flutter/material.dart';
import 'package:minimicro/constants.dart';
import 'package:minimicro/shared_state/shared_state.dart';
import 'package:minimicro/widgets/display.dart';
import 'package:minimicro/widgets/solid_color_display.dart';

/// Simply displays the same color across
/// the whole screen. Translucent colors
/// work too. Useful for fade in/out or as
/// background.
class SolidColorDisplaySharedState extends SharedState {
  Color color = defaultSolidColorDisplayBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return SolidColorDisplay(sharedState: this);
  }

  @override
  DisplayType get type => DisplayType.solidColor;
}
