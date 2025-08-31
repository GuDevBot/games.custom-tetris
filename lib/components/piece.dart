import 'package:custom_tetris/values.dart';
import 'package:flutter/material.dart';

class Piece {
  Tetronimo type;
  List<List<int>> shape = [];
  int row = 0;
  int col = 0;
  int rotationState = 0;

  Color get color {
    return tetronimoColors[type]!;
  }

  Piece({required this.type}) {
    initializePiece();
  }

  void initializePiece() {
    // Define the shape based on the type
    switch (type) {
      case Tetronimo.L:
        shape = [
          [0, 1, 0],
          [0, 1, 0],
          [0, 1, 1],
        ];
        break;
      case Tetronimo.J:
        shape = [
          [0, 1, 0],
          [0, 1, 0],
          [1, 1, 0],
        ];
        break;
      case Tetronimo.I:
        shape = [
          [0, 0, 0, 0],
          [1, 1, 1, 1],
          [0, 0, 0, 0],
          [0, 0, 0, 0],
        ];
        break;
      case Tetronimo.O:
        shape = [
          [1, 1],
          [1, 1],
        ];
        break;
      case Tetronimo.S:
        shape = [
          [0, 1, 1],
          [1, 1, 0],
          [0, 0, 0],
        ];
        break;
      case Tetronimo.Z:
        shape = [
          [1, 1, 0],
          [0, 1, 1],
          [0, 0, 0],
        ];
        break;
      case Tetronimo.T:
        shape = [
          [0, 0, 0],
          [1, 1, 1],
          [0, 1, 0],
        ];
        break;
    }
    // Initial position at the top center of the board
    row = -2;
    col = 3;
  }

  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        row++;
        break;
      case Direction.left:
        col--;
        break;
      case Direction.right:
        col++;
        break;
    }
  }

  void rotatePiece() {
    if (type == Tetronimo.O) return;

    List<List<int>> newShape = List.generate(
      shape[0].length,
      (i) => List.generate(shape.length, (j) => 0),
    );

    for (int i = 0; i < shape.length; i++) {
      for (int j = 0; j < shape[i].length; j++) {
        newShape[j][shape.length - 1 - i] = shape[i][j];
      }
    }

    shape = newShape;
    rotationState = (rotationState + 1) % 4;
  }
}