import 'package:minimicro/widgets/display.dart';
import 'package:miniscript/miniscript_tac/machine.dart';
import 'package:miniscript/miniscript_types/value_map.dart';
import 'package:miniscript/miniscript_types/value_string.dart';

var displayModeMap =
    ValMap()
      ..setElem(ValString("off"), ValMap()..userData = DisplayType.off)
      ..setElem(
        ValString("solidColor"),
        ValMap()..userData = DisplayType.solidColor,
      )
      ..setElem(ValString("text"), ValMap()..userData = DisplayType.text)
      ..setElem(ValString("pixel"), ValMap()..userData = DisplayType.pixel)
      ..setElem(ValString("tile"), ValMap()..userData = DisplayType.tile)
      ..setElem(ValString("sprite"), ValMap()..userData = DisplayType.sprite);

void addDisplayValues(Machine vm) {
  vm.globalContext!.setVar("displayMode", displayModeMap);
}
