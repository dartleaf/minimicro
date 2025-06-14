import 'package:flutter/material.dart';
import 'package:minimicro/widgets/display.dart';

abstract class SharedState extends ChangeNotifier {
  abstract final DisplayType type;
  T setState<T>(T Function() fn) {
    final v = fn();
    notifyListeners();
    return v;
  }

  Widget build(BuildContext context);
}
