import 'package:flutter/material.dart';
import 'package:minimicro/widgets/display.dart';

abstract class SharedState extends ChangeNotifier {
  abstract final DisplayType type;
  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }

  Widget build(BuildContext context);
}
