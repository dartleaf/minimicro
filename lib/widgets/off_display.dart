import 'package:flutter/widgets.dart';
import 'package:minimicro/widgets/display.dart';

/// A widget that represents an "off" display, which does not render anything.
class OffDisplay extends Display {
  const OffDisplay({super.key, required super.sharedState});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
