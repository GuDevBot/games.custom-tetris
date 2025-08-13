import 'package:flutter/material.dart';

  // dimensions
  int rowLength = 10;
  int colLength = 15;

enum Direction{
  left,
  right,
  down
}

enum Tetronimo{
  L,
  J,
  I,
  O,
  S,
  Z,
  T,
}

final Map<Tetronimo, Color> tetronimoColors = {
  Tetronimo.L: L,
  Tetronimo.J: J,
  Tetronimo.I: I,
  Tetronimo.O: O,
  Tetronimo.S: S,
  Tetronimo.Z: Z,
  Tetronimo.T: T,
};

Color L = Colors.orange;
Color J = Colors.blue;
Color I = Colors.purple;
Color O = Colors.amber;
Color S = Colors.green;
Color Z = Colors.red;
Color T = Colors.cyan;
