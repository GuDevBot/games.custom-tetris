import 'package:custom_tetris/game_board.dart';
import 'package:custom_tetris/values.dart';
import 'package:flutter/material.dart';

class Piece {
  Tetronimo type;
  int lowest;

  Piece({required this.type, this.lowest = 14});

  List<int> position = [];

  Color get color {
    return tetronimoColors[type] ?? Colors.white;
  }

  void inicializePiece() {
    switch (type) {
      case Tetronimo.L:
        position = [
          lowest,
          lowest + rowLength,
          lowest - rowLength,
          lowest + rowLength + 1,
        ];
        break;
      case Tetronimo.J:
        position = [
          lowest,
          lowest + rowLength,
          lowest + (rowLength * 2),
          lowest + (rowLength * 2) - 1,
        ];
        break;
      case Tetronimo.I:
        position = [lowest, lowest + 1, lowest + 2, lowest + 3];
        break;
      case Tetronimo.O:
        position = [
          lowest,
          lowest + rowLength,
          lowest - 1,
          lowest + rowLength - 1,
        ];
        break;
      case Tetronimo.S:
        position = [
          lowest,
          lowest - 1,
          lowest - rowLength,
          lowest - rowLength + 1,
        ];
        break;
      case Tetronimo.Z:
        position = [
          lowest,
          lowest + 1,
          lowest - rowLength,
          lowest - rowLength - 1,
        ];
        break;
      case Tetronimo.T:
        position = [
          lowest,
          lowest - rowLength,
          lowest - rowLength + 1,
          lowest - (rowLength * 2),
        ];
        break;
    }
  }

  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLength;
        }
        break;
      case Direction.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      case Direction.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
    }
  }

  int rotationState = 1;
  void rotatePiece() {
    // new position
    List<int> newPosition = [];

    // rotate the piece based on it's type
    switch (type) {
      case Tetronimo.L:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
          case 1:
            newPosition = [
              position[1] - rowLength + 1,
              position[1],
              position[1] - 1,
              position[1] + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
          case 2:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] - rowLength - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
          case 3:
            newPosition = [
              position[1] + rowLength - 1,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;
      case Tetronimo.J:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
          case 1:
            newPosition = [
              position[1] - rowLength - 1,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
          case 2:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] - rowLength + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
          case 3:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] - (rowLength * 2),
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;
      case Tetronimo.I:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
          case 1:
            newPosition = [
              position[1] - rowLength - 1,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
          case 2:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] - rowLength + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
          case 3:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] - (rowLength * 2),
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;
      case Tetronimo.O:
        switch (rotationState) {
          case 0:
            break;
        }
        break;
      case Tetronimo.S:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
          case 1:
            newPosition = [
              position[1] - rowLength - 1,
              position[1],
              position[1] + 1,
              position[1] + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
          case 2:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] - rowLength - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
          case 3:
            newPosition = [
              position[1] - rowLength + 1,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;
      case Tetronimo.Z:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
          case 1:
            newPosition = [
              position[1] - rowLength - 1,
              position[1],
              position[1] + 1,
              position[1] + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
          case 2:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] - rowLength - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
          case 3:
            newPosition = [
              position[1] - rowLength + 1,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;
      case Tetronimo.T:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + 1,
              position[1] + rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
          case 1:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
          case 2:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
          case 3:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] - rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;
    }
  }

  bool positionIsValid(int position) {
    // get the position
    int row = (position / rowLength).floor();
    int col = position % rowLength;

    //
    if (row < 0 || col < 0 || gameBoard[row][col] != null ) {
      return false;
    } else {
      return true;
    }
  }

  bool piecePositionIsValid(List<int> piecePosition) {
    bool firstColOccupied = false;
    bool lastColOccupied = false;

    for (int pos in piecePosition) {
      if (positionIsValid(pos) != true) {
        return false;
      }

      int col = pos % rowLength;

      if (col == 0) firstColOccupied = true;
      if (col == rowLength - 1) lastColOccupied = true;
    }

    return !(firstColOccupied && lastColOccupied);
  }
}
