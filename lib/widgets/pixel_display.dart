import 'package:flutter/widgets.dart';
import 'package:minimicro/constants.dart';
import 'package:minimicro/shared_state/pixel_display_shared_state.dart';
import 'package:minimicro/widgets/display.dart';

class PixelDisplay extends Display<PixelDisplaySharedState> {
  const PixelDisplay({super.key, required super.sharedState});

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      sharedState.imageBytes.buffer.asUint8List(),
      width: displayWidth,
      height: displayHeight,
    );
  }
}
