import 'package:flutter/material.dart';
import 'package:minimicro/shared_state/shared_state.dart';
import 'package:minimicro/widgets/display.dart';
import 'package:minimicro/widgets/off_display.dart';

class OffDisplaySharedState extends SharedState {
  @override
  final DisplayType type = DisplayType.off;

  @override
  Widget build(BuildContext context) {
    return OffDisplay(sharedState: this);
  }
}
