import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:custom_tetris/components/piece.dart';
import 'package:custom_tetris/components/pixel.dart';
import 'package:custom_tetris/values.dart';
import 'package:flutter/material.dart';

// Cria o tabuleiro do jogo como uma matriz 2D vazia
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
  // Peça atual
  Piece currentPiece = Piece(type: Tetronimo.L);
  int score = 0;
  bool gameOver = false;

  // NOVO: Players de áudio
  final AudioPlayer backgroundMusicPlayer = AudioPlayer();
  final AudioPlayer soundEffectPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    startGame();
  }
  
  @override
  void dispose() {
    // Para a música ao sair da tela
    backgroundMusicPlayer.dispose();
    soundEffectPlayer.dispose();
    super.dispose();
  }


  void startGame() {
    playBackgroundMusic();
    
    createNewPiece();
    Duration frameRate = const Duration(milliseconds: 600);
    gameLoop(frameRate);
  }

  // Funções de áudio
  void playBackgroundMusic() async {
    await backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
    await backgroundMusicPlayer.play(AssetSource('audio/background_music.mp3'));
  }

  void playSoundEffect(String sound) async {
    await soundEffectPlayer.play(AssetSource('audio/$sound'));
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      if (gameOver) {
        timer.cancel();
        showGameOverDialog();
        return;
      }
      setState(() {
        clearLines();
        if (!checkCollision(Direction.down, currentPiece)) {
          currentPiece.movePiece(Direction.down);
        } else {
          landPiece();
        }
      });
    });
  }

  void showGameOverDialog() {
    backgroundMusicPlayer.stop();
    playSoundEffect('game_over.mp3');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Game Over"),
        content: Text("Sua pontuação: $score"),
        actions: [
          TextButton(
            onPressed: () {
              resetGame();
              Navigator.pop(context);
            },
            child: const Text("Jogar Novamente"),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    gameBoard = List.generate(colLength, (i) => List.generate(rowLength, (j) => null));
    gameOver = false;
    score = 0;
    startGame();
  }

  bool checkCollision(Direction direction, Piece piece) {
    for (int i = 0; i < piece.shape.length; i++) {
      for (int j = 0; j < piece.shape[i].length; j++) {
        if (piece.shape[i][j] == 1) {
          int newRow = piece.row + i;
          int newCol = piece.col + j;

          if (direction == Direction.down) newRow++;
          if (direction == Direction.left) newCol--;
          if (direction == Direction.right) newCol++;

          if (newRow >= colLength || newCol < 0 || newCol >= rowLength) {
            return true;
          }
          if (newRow >= 0 && gameBoard[newRow][newCol] != null) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void landPiece() {
    // Toca o som da peça aterrissando
    playSoundEffect('landing.mp3');

    for (int i = 0; i < currentPiece.shape.length; i++) {
      for (int j = 0; j < currentPiece.shape[i].length; j++) {
        if (currentPiece.shape[i][j] == 1) {
          int row = currentPiece.row + i;
          int col = currentPiece.col + j;
          if (row >= 0 && col >= 0) {
            gameBoard[row][col] = currentPiece.type;
          }
        }
      }
    }
    
    setState(() {
      score += pointsPerPiece;
    });

    if (isGameOver()) {
      gameOver = true;
    } else {
      createNewPiece();
    }
  }

  bool isGameOver() {
    for (int j = 0; j < rowLength; j++) {
      if (gameBoard[0][j] != null) {
        return true;
      }
    }
    return false;
  }

  void createNewPiece() {
    Random rand = Random();
    Tetronimo randomType = Tetronimo.values[rand.nextInt(Tetronimo.values.length)];
    currentPiece = Piece(type: randomType);
  }
  
  void clearLines() {
    int linesCleared = 0;
    for (int row = colLength - 1; row >= 0; row--) {
      bool isLineFull = true;
      for (int col = 0; col < rowLength; col++) {
        if (gameBoard[row][col] == null) {
          isLineFull = false;
          break;
        }
      }

      if (isLineFull) {
        linesCleared++;
        for (int r = row; r > 0; r--) {
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }
        gameBoard[0] = List.generate(rowLength, (index) => null);
        row++;
      }
    }

    if (linesCleared > 0) {
      playSoundEffect('clear_line.mp3');

      setState(() {
        score += pointsPerLine[linesCleared] ?? 0;
      });
    }
  }

  void moveLeft() {
    if (!checkCollision(Direction.left, currentPiece)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  void moveRight() {
    if (!checkCollision(Direction.right, currentPiece)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  void rotatePiece() {
    setState(() {
      Piece testPiece = Piece(type: currentPiece.type);
      testPiece.row = currentPiece.row;
      testPiece.col = currentPiece.col;
      testPiece.shape = List.from(currentPiece.shape);
      testPiece.rotatePiece();
      if (!checkCollision(Direction.down, testPiece) &&
          !checkCollision(Direction.right, testPiece) &&
          !checkCollision(Direction.left, testPiece)) {
        currentPiece.rotatePiece();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
            child: Text(
              "Score: $score",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowLength,
              ),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rowLength * colLength,
              itemBuilder: (context, index) {
                int row = (index / rowLength).floor();
                int col = index % rowLength;
                bool isCurrentPiecePixel = false;
                for (int i = 0; i < currentPiece.shape.length; i++) {
                  for (int j = 0; j < currentPiece.shape[i].length; j++) {
                    if (currentPiece.shape[i][j] == 1) {
                      if (currentPiece.row + i == row && currentPiece.col + j == col) {
                        isCurrentPiecePixel = true;
                        break;
                      }
                    }
                  }
                  if (isCurrentPiecePixel) break;
                }
                if (isCurrentPiecePixel) {
                  return Pixel(color: currentPiece.color);
                } else if (gameBoard[row][col] != null) {
                  final Tetronimo? tetronimoType = gameBoard[row][col];
                  return Pixel(color: tetronimoColors[tetronimoType]);
                } else {
                  return Pixel(color: Colors.grey[900]);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(onPressed: moveLeft, color: Colors.white, icon: const Icon(Icons.arrow_back_ios_new)),
                IconButton(onPressed: rotatePiece, color: Colors.white, icon: const Icon(Icons.rotate_right)),
                IconButton(onPressed: moveRight, color: Colors.white, icon: const Icon(Icons.arrow_forward_ios)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}