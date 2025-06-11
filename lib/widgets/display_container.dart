import 'package:flutter/widgets.dart';
import 'package:minimicro/constants.dart';

import 'package:minimicro/shared_state/shared_state.dart';

/// A widget that displays a child widget within a container that maintains
/// a specific aspect ratio, capturing its rendering as an image.
class DisplayContainer extends StatefulWidget {
  final SharedState sharedState;

  const DisplayContainer({super.key, required this.sharedState});

  @override
  State<DisplayContainer> createState() => _DisplayContainerState();
}

class _DisplayContainerState extends State<DisplayContainer> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.sharedState,
      builder:
          (context, _) => SizedBox(
            width: displayWidth,
            height: displayHeight,
            child: widget.sharedState.build(context),
          ),
    );
  }
}
