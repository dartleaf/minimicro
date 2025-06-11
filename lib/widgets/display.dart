import 'package:flutter/cupertino.dart';

abstract class Display<SharedState> extends StatelessWidget {
  final SharedState sharedState;

  const Display({super.key, required this.sharedState});
}

enum DisplayType { off, solidColor, text, pixel, tile, sprite }
