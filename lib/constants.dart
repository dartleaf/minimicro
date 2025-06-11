import 'package:flutter/material.dart';

const displayWidth = 960.0;
const displayHeight = 640.0;
const textRowSize = 68;
const textColumnSize = 26 + 1;
const textOffsetX = 4.0;
const textOffsetY = 8.0;

const charWidth = (displayWidth - textOffsetX * 2) / textRowSize;
const charHeight = (displayHeight - textOffsetY * 2) / textColumnSize;

const defaultSolidColorDisplayBackgroundColor = Colors.blue;

const defaultTextDisplayTextColor = Colors.orangeAccent;
const defaultTextDisplayBackgroundColor = Colors.black;
const defaultTextDisplayDelimeter = "\n";
const defaultTextDisplayColumn = 0;
const defaultTextDisplayRow = 0;
