import 'package:flutter/material.dart';
import 'package:minimicro/constants.dart';
import 'package:minimicro/shared_state/shared_state.dart';
import 'package:minimicro/widgets/display.dart';
import 'package:minimicro/widgets/text_display.dart';

class CharText {
  final String character;
  Color textColor;
  Color backColor;

  CharText({
    required this.character,
    required this.textColor,
    required this.backColor,
  });
}

/// A 68-by-26 character display. Every cell
/// may have its own colors and inverse
/// mode.
class TextDisplaySharedState extends SharedState {
  /// Text color for the display.
  Color color = defaultTextDisplayTextColor;

  /// Background color for the display.
  Color backColor = defaultTextDisplayBackgroundColor;

  /// Cursor position in the text grid.
  int column = defaultTextDisplayColumn;

  /// Cursor position in the text grid.
  int row = defaultTextDisplayRow;

  /// Delimiter used to separate printed lines.
  String delimeter = defaultTextDisplayDelimeter;

  /// Whether to invert the text display colors.
  /// If true, text color becomes background color and vice versa.
  bool inverse = false;

  /// Text grid dimensions.
  List<List<CharText>> textGrid = List.generate(
    textColumnSize,
    (_) =>
        List.filled(textRowSize, " ")
            .map(
              (c) => CharText(
                character: c,
                backColor: defaultTextDisplayBackgroundColor,
                textColor: defaultTextDisplayTextColor,
              ),
            )
            .toList(),
  );

  CharText newCharText(String character) {
    return CharText(
      character: character,
      textColor: color,
      backColor: backColor,
    );
  }

  bool _isFirst = true;

  /// Print a string to the text display, acting like a terminal.
  /// New text replaces old text when scrolling beyond display limits.
  /// Appends the configured delimeter at the end of the print.
  void print(String s) {
    setState(() {
      if (!_isFirst) {
        // Add delimeter at the first if it's not empty
        if (delimeter.isNotEmpty) {
          printWithoutDelimeter(delimeter);
        }
      }

      printWithoutDelimeter(s);

      _isFirst = false;
    });
  }

  void printWithoutDelimeter(String s) {
    // Split the string into lines
    final lines = s.split("\n");

    // Process each line
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Process each character in the current line
      for (final char in line.characters) {
        textGrid[row][column] = newCharText(char);
        _advanceColumn();
      }

      // Move to next line if this isn't the last line
      if (i < lines.length - 1 && column != 0) {
        _advanceLine();
      }
    }
  }

  /// Advance cursor to the next column, handling row wrapping and scrolling
  void _advanceColumn() {
    column++;
    if (column >= textRowSize) {
      column = 0;
      _advanceRow();
    }
  }

  /// Advance cursor to the next row, handling scrolling if needed
  void _advanceRow() {
    row++;
    if (row >= textColumnSize) {
      _scrollUp();
    }
  }

  /// Move to the beginning of the next line
  void _advanceLine() {
    column = 0;
    _advanceRow();
  }

  /// Scrolls the text display up by one line
  void _scrollUp() {
    // Shift all lines up by one
    for (int y = 0; y < textColumnSize - 1; y++) {
      textGrid[y] = textGrid[y + 1];
    }

    // Clear the last row
    textGrid[textColumnSize - 1] = List.generate(
      textRowSize,
      (_) => newCharText(" "),
    );

    // Keep cursor at the bottom row
    row = textColumnSize - 1;
  }

  /// Clear the display, resetting all text and cursor position.
  void clear() {
    setState(() {
      textGrid = List.generate(
        textColumnSize,
        (_) =>
            List.filled(textRowSize, " ").map((c) => newCharText(" ")).toList(),
      );
      column = 0;
      row = 0;
      inverse = false;
    });
  }

  /// Get the character at the specified column and row.
  String cell(int x, int y) {
    if (y < 0 || y >= textColumnSize || x < 0 || x >= textRowSize) return "";
    return textGrid[y][x].character;
  }

  /// Set the character at the specified column and row.
  void setCell(int x, int y, String k) {
    if (x >= 0 && x < textRowSize && y >= 0 && y < textColumnSize) {
      setState(() {
        textGrid[y][x] = CharText(
          character: k,
          textColor: textGrid[y][x].textColor,
          backColor: textGrid[y][x].backColor,
        );
      });
    }
  }

  /// Get the text color for the specified cell.
  Color cellColor(int x, int y) {
    return textGrid[y][x].textColor;
  }

  /// Set the text color for the specified cell.
  void setCellColor(int x, int y, Color c) {
    setState(() {
      textGrid[y][x].textColor = c;
    });
  }

  /// Get the background color for the specified cell.
  Color cellBackColor(int x, int y) {
    return textGrid[y][x].backColor;
  }

  /// Set the background color for the specified cell.
  void setCellBackColor(int x, int y, Color c) {
    setState(() {
      textGrid[y][x].backColor = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextDisplay(sharedState: this);
  }

  @override
  DisplayType get type => DisplayType.text;
}
