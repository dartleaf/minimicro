import 'package:flutter/material.dart';
import 'package:minimicro/shared_state/shared_state.dart';
import 'package:minimicro/widgets/display.dart';
import 'package:minimicro/widgets/sprite_display.dart';

class SpriteDisplaySharedState extends SharedState {
  @override
  Widget build(BuildContext context) {
    return SpriteDisplay(sharedState: this);
  }

  @override
  DisplayType get type => DisplayType.sprite;
}
