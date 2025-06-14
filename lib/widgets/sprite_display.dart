import 'package:flutter/widgets.dart';
import 'package:minimicro/shared_state/sprite_display_shared_state.dart';
import 'package:minimicro/widgets/display.dart';

class SpriteDisplay extends Display<SpriteDisplaySharedState> {
  const SpriteDisplay({super.key, required super.sharedState});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (final sprite in sharedState.sprites)
          Positioned(
            left: sprite.x.toDouble(),
            bottom: sprite.y.toDouble(),
            child: RawImage(
              image: sprite.image,
              width: sprite.image.width.toDouble(),
              height: sprite.image.height.toDouble(),
            ),
          ),
      ],
    );
  }
}
