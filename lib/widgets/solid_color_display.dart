import 'package:flutter/widgets.dart';
import 'package:minimicro/shared_state/solid_color_display_shared_state.dart';
import 'package:minimicro/widgets/display.dart';

/// A widget that displays a solid color.
class SolidColorDisplay extends Display<SolidColorDisplaySharedState> {
  const SolidColorDisplay({super.key, required super.sharedState});

  @override
  Widget build(BuildContext context) {
    return Container(color: sharedState.color);
  }
}
