import 'package:flutter/material.dart';

// dimensions
const int rowLength = 10;
const int colLength = 15;

enum Direction { left, right, down }

enum Tetronimo { L, J, I, O, S, Z, T }

final Map<Tetronimo, Color> tetronimoColors = {
  Tetronimo.L: Colors.orange,
  Tetronimo.J: Colors.blue,
  Tetronimo.I: Colors.cyan,
  Tetronimo.O: Colors.yellow,
  Tetronimo.S: Colors.green,
  Tetronimo.Z: Colors.red,
  Tetronimo.T: Colors.purple,
};

// Sistema de pontuação
const int pointsPerPiece = 5; // Pontos por peça que aterrissa
const Map<int, int> pointsPerLine = {
  1: 100, 
  2: 300, 
  3: 500, 
  4: 800, // Tetris
};
