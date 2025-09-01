import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:custom_tetris/components/piece.dart';
import 'package:custom_tetris/components/pixel.dart';
import 'package:custom_tetris/values.dart';
import 'package:flutter/material.dart';

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
  int score = 0;
  bool gameOver = false;
  bool isPaused = false;
  Timer? gameTimer;
  Timer? _moveDownTimer;

  final AudioPlayer backgroundMusicPlayer = AudioPlayer();
  final AudioPlayer soundEffectPlayer = AudioPlayer();

  final AudioContext _audioContextMusic = AudioContext(
    android: const AudioContextAndroid(
      isSpeakerphoneOn: true,
      stayAwake: true,
      contentType: AndroidContentType.music,
      usageType: AndroidUsageType.media,
      audioFocus: AndroidAudioFocus.gain,
    ),
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.playback,
      options: {AVAudioSessionOptions.mixWithOthers},
    ),
  );

  final AudioContext _audioContextEffects = AudioContext(
    android: const AudioContextAndroid(
      isSpeakerphoneOn: true,
      stayAwake: true,
      contentType: AndroidContentType.sonification,
      usageType: AndroidUsageType.game,
      audioFocus: AndroidAudioFocus.gainTransientMayDuck,
    ),
    iOS: AudioContextIOS(category: AVAudioSessionCategory.ambient),
  );

  @override
  void initState() {
    super.initState();
    backgroundMusicPlayer.setAudioContext(_audioContextMusic);
    soundEffectPlayer.setAudioContext(_audioContextEffects);

    startGame();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
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

  void playBackgroundMusic() async {
    await backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
    await backgroundMusicPlayer.play(AssetSource('audio/background_music.mp3'));
  }

  void playSoundEffect(String sound) async {
    await soundEffectPlayer.play(AssetSource('audio/$sound'));
  }

  void gameLoop(Duration frameRate) {
    gameTimer = Timer.periodic(frameRate, (timer) {
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

  void togglePause() {
    setState(() {
      isPaused = !isPaused;
      if (isPaused) {
        gameTimer?.cancel();
        backgroundMusicPlayer.pause();
      } else {
        backgroundMusicPlayer.resume();
        startGame();
      }
    });
  }

  void showGameOverDialog() {
    gameTimer?.cancel();
    backgroundMusicPlayer.stop();
    playSoundEffect('game_over.mp3');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.blueGrey,
            title: const Text(
              "Game Over",
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
            content: Text(
              "Score: $score",
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  resetGame();
                  Navigator.pop(context);
                },
                child: const Text("Play Again"),
              ),
            ],
          ),
    );
  }

  void resetGame() {
    gameBoard = List.generate(
      colLength,
      (i) => List.generate(rowLength, (j) => null),
    );
    gameOver = false;
    isPaused = false;
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
    if (isPaused) return;
    Random rand = Random();
    Tetronimo randomType =
        Tetronimo.values[rand.nextInt(Tetronimo.values.length)];
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
    if (isPaused) return;
    if (!checkCollision(Direction.left, currentPiece)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  void moveRight() {
    if (isPaused) return;
    if (!checkCollision(Direction.right, currentPiece)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  void moveDown() {
    if (isPaused) return;
    if (!checkCollision(Direction.down, currentPiece)) {
      setState(() {
        currentPiece.movePiece(Direction.down);
      });
    }
  }

  void startContinuousMoveDown() {
    moveDown();
    _moveDownTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      moveDown();
    });
  }

  void stopContinuousMoveDown() {
    if (_moveDownTimer != null && _moveDownTimer!.isActive) {
      _moveDownTimer!.cancel();
    }
  }

  void rotatePiece() {
    if (isPaused) return;
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
      body: Stack(
        children: [
          Column(
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
                          if (currentPiece.row + i == row &&
                              currentPiece.col + j == col) {
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
                    IconButton(
                      onPressed: isPaused ? null : moveLeft,
                      color: Colors.white,
                      icon: const Icon(Icons.arrow_back_ios_new, size: 40),
                    ),
                    IconButton(
                      onPressed: isPaused ? null : rotatePiece,
                      color: Colors.white,
                      icon: const Icon(Icons.rotate_right, size: 40),
                    ),
                    GestureDetector(
                      onLongPressStart: (_) {
                        if (!isPaused) {
                          startContinuousMoveDown();
                        }
                      },
                      onLongPressEnd: (_) {
                        stopContinuousMoveDown();
                      },
                      child: IconButton(
                        onPressed: isPaused ? null : moveDown,
                        color: Colors.white,
                        icon: const Icon(Icons.arrow_downward, size: 40),
                      ),
                    ),
                    IconButton(
                      onPressed: isPaused ? null : moveRight,
                      color: Colors.white,
                      icon: const Icon(Icons.arrow_forward_ios, size: 40),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0, right: 20.0),
              child: IconButton(
                icon: Icon(
                  isPaused ? Icons.play_arrow : Icons.pause,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: togglePause,
              ),
            ),
          ),
          if (isPaused)
            Container(
              color: Colors.black12,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Paused',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    IconButton(
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 50,
                      ),
                      onPressed: togglePause,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
