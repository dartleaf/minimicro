import 'package:flutter/material.dart';
import 'package:minimicro/constants.dart';
import 'package:minimicro/shared_state/off_display_shared_state.dart';
import 'package:minimicro/shared_state/pixel_display_shared_state.dart';
import 'package:minimicro/shared_state/shared_state.dart';
import 'package:minimicro/shared_state/solid_color_display_shared_state.dart';
import 'package:minimicro/shared_state/sprite_display_shared_state.dart';
import 'package:minimicro/shared_state/text_display_shared_state.dart';
import 'package:minimicro/widgets/display_container.dart';

class MiniMicro extends StatefulWidget {
  const MiniMicro({super.key});

  @override
  State<MiniMicro> createState() => _MiniMicroState();
}

class _MiniMicroState extends State<MiniMicro> {
  final List<SharedState> sharedStates = [
    SolidColorDisplaySharedState(),
    OffDisplaySharedState(),
    PixelDisplaySharedState(),
    SpriteDisplaySharedState(),
    TextDisplaySharedState(),
    OffDisplaySharedState(),
    OffDisplaySharedState(),
  ];

  _MiniMicroState() {
    final textDisplay = sharedStates[4] as TextDisplaySharedState;
    textDisplay.print("This shouldn't be visible");
    textDisplay.print("This should be visible");
    for (int i = 1; i < textColumnSize - 3; i++) {
      textDisplay.print("$i Hello");
    }
    textDisplay.print(List.filled(textRowSize, "A").join(""));
    textDisplay.print("This should be visible");
    textDisplay.print("eol");
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AspectRatio(
          aspectRatio: displayWidth / displayHeight,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Stack(
              children:
                  sharedStates
                      .map(
                        (sharedState) =>
                            DisplayContainer(sharedState: sharedState),
                      )
                      .toList(),
            ),
          ),
        );
      },
    );
  }
}
