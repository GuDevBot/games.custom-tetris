import 'package:custom_tetris/values.dart';
import 'package:flutter/material.dart';

class Piece {
  // tipo do tetronimo (L, J, T, etc)
  Tetronimo type;

  // formato da peça
  List<List<int>> shape = [];

  // posição da peça no tabuleiro
  int row = 0;
  int col = 0;

  // estado da rotação
  int rotationState = 0;

  // cor da peça
  Color get color {
    return tetronimoColors[type]!;
  }

  Piece({required this.type}) {
    // inicializa a peça com sua forma e posição
    initializePiece();
  }

  void initializePiece() {
    // Define a forma de cada peça como uma matriz 2D
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

    // Posição inicial no topo e no centro
    row = -2; // Começa um pouco acima da tela
    col = 3;
  }

  // move a peça
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

  // rotaciona a peça
  void rotatePiece() {
    // A peça 'O' não rotaciona
    if (type == Tetronimo.O) return;

    // Algoritmo de Rotação
    List<List<int>> newShape = List.generate(
      shape[0].length,
      (i) => List.generate(shape.length, (j) => 0),
    );

    for (int i = 0; i < shape.length; i++) {
      for (int j = 0; j < shape[i].length; j++) {
        // transpõe e reverte as linhas para girar 90 graus
        newShape[j][shape.length - 1 - i] = shape[i][j];
      }
    }

    // atualiza o formato
    shape = newShape;
    rotationState = (rotationState + 1) % 4;
  }
}
