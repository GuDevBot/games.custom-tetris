import 'dart:math';
import 'package:custom_tetris/components/piece.dart';
import 'package:custom_tetris/values.dart';
import 'package:flutter/material.dart';
import 'components/pixel.dart';
import 'dart:async';

List<List<Tetronimo?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(rowLength, (j) => null),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Piece currentPiece = Piece(type: Tetronimo.L);
  bool gameOver = false;

  @override
  void initState() {
    super.initState();

    startGame();
  }

  void startGame() {
    currentPiece.inicializePiece();

    // frame durarion rate
    Duration frameRate = const Duration(milliseconds: 800);
    gameLoop(frameRate);
  }

  void checkGameOver() {
    for (int pos in currentPiece.position) {
      if ((pos / rowLength).floor() < 2) {
        gameOver = true;
        break;
      }
    }
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        checkLanding();
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  bool checkCollision(Direction direction) {
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      // adjust the values
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      // check if exists collision.
      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }
    }

    // if no collision have been detected It returns false
    return false;
  }

  void checkLanding() {
    if (checkCollision(Direction.down)) {
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        } else {
          null;
        }
      }
      createNewPiece();
    }
  }

  void createNewPiece() {
    Random rand = Random();
    Tetronimo randomType =
        Tetronimo.values[rand.nextInt(Tetronimo.values.length)];
    currentPiece = Piece(type: randomType, lowest: 14);
    currentPiece.inicializePiece();
  }

  void moveLeft() {
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  void moveRight() {
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowLength,
              ),
              physics: NeverScrollableScrollPhysics(),
              itemCount: rowLength * colLength,
              itemBuilder: (context, index) {
                int row = (index / rowLength).floor();
                int col = index % rowLength;

                if (currentPiece.position.contains(index)) {
                  // current piece
                  return Pixel(color: currentPiece.color, index: index);
                } else if (gameBoard[row][col] != null) {
                  // other pieces.
                  final Tetronimo? tetronimoType = gameBoard[row][col];
                  return Pixel(
                    color: tetronimoColors[tetronimoType],
                    index: index,
                  );
                } else {
                  // board pixel
                  return Pixel(color: Colors.grey[900], index: index);
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: moveLeft,
                color: Colors.white,
                icon: Icon(Icons.arrow_back_ios),
              ),
              IconButton(
                onPressed: rotatePiece,
                color: Colors.white,
                icon: Icon(Icons.rotate_right),
              ),
              IconButton(
                onPressed: moveRight,
                color: Colors.white,
                icon: Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
