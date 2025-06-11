import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimicro/constants.dart';
import 'package:minimicro/shared_state/text_display_shared_state.dart';
import 'package:minimicro/widgets/display.dart';

/// A widget that displays text in a grid format using Canvas,
/// with customizable colors and cursor position.
class TextDisplay extends Display<TextDisplaySharedState> {
  const TextDisplay({super.key, required super.sharedState});

  @override
  Widget build(BuildContext context) {
    return TextGridInternal(
      textGrid: sharedState.textGrid,
      defaultTextColor: sharedState.color,
      defaultBackColor: sharedState.backColor,
      inverse: sharedState.inverse,
    );
  }
}

class TextGridInternal extends StatefulWidget {
  final List<List<CharText>> textGrid;
  final Color defaultTextColor;
  final Color defaultBackColor;
  final bool inverse;

  const TextGridInternal({
    super.key,
    required this.textGrid,
    required this.defaultTextColor,
    required this.defaultBackColor,
    required this.inverse,
  });

  @override
  State<TextGridInternal> createState() => _TextGridInternalState();
}

class _TextGridInternalState extends State<TextGridInternal> {
  Color get textColor =>
      widget.inverse ? widget.defaultBackColor : widget.defaultTextColor;

  Color get backColor =>
      widget.inverse ? widget.defaultTextColor : widget.defaultBackColor;

  Color? getTextColor(int y, int x) {
    final charText = widget.textGrid[y][x];
    return widget.inverse ? charText.backColor : charText.textColor;
  }

  Color? getBackColor(int y, int x) {
    final charText = widget.textGrid[y][x];
    return widget.inverse ? charText.textColor : charText.backColor;
  }

  List<List<bool>> isSelectedList = List.generate(
    textColumnSize,
    (_) => List.filled(textRowSize, false),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backColor,
      padding: const EdgeInsets.symmetric(
        horizontal: textOffsetX,
        vertical: textOffsetY,
      ),
      child: Center(
        child: SizedBox(
          width: displayWidth,
          height: displayHeight,
          child: Builder(
            builder: (context) {
              final textSpans = <TextSpan>[];
              for (int col = 0; col < textColumnSize; col++) {
                for (int row = 0; row < textRowSize; row++) {
                  final cellText = widget.textGrid[col][row];
                  var color = getTextColor(col, row) ?? textColor;
                  var backColor = getBackColor(col, row) ?? this.backColor;

                  if (isSelectedList[col][row]) {
                    // If the cell is selected, change the background color
                    backColor = color.withValues(alpha: 0.5);
                  }

                  textSpans.add(
                    TextSpan(
                      text: cellText.character,
                      style: TextStyle(
                        backgroundColor: backColor,
                        color: color,
                      ),
                    ),
                  );
                }

                textSpans.add(TextSpan(text: '\n'));
              }

              return TextSelectionTheme(
                data: TextSelectionThemeData(
                  cursorColor: Colors.transparent,
                  selectionColor: Colors.transparent,
                  selectionHandleColor: Colors.transparent,
                ),
                child: SelectableText.rich(
                  TextSpan(children: textSpans),

                  onSelectionChanged: (selection, cause) {
                    setState(() {
                      final start = selection.start;
                      final end = selection.end;

                      // Set all cells based on the selection range
                      for (int col = 0; col < textColumnSize; col++) {
                        for (int row = 0; row < textRowSize; row++) {
                          final index =
                              col * (textRowSize + 1) +
                              row; // +1 for newline character
                          if (index >= start && index < end) {
                            isSelectedList[col][row] = true;
                          } else {
                            isSelectedList[col][row] = false;
                          }
                        }
                      }
                    });
                  },
                  maxLines: textColumnSize,
                  scrollBehavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                  style: GoogleFonts.robotoMono().copyWith(
                    fontSize: charHeight * 0.6,
                    letterSpacing: charWidth * 0.18,
                    height: 1.3,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.justify,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
