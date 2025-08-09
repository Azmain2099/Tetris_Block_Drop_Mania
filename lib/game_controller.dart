import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notun/models/piece.dart';
import 'package:notun/services/sound_service.dart';

class GameController extends ChangeNotifier {
  static const int width = 10;
  static const int height = 20;

  List<List<Color?>> board = [];
  Piece? currentPiece;
  Piece? nextPiece;
  Piece? holdPiece;
  bool canHold = true;
  int score = 0;
  int highScore = 0;
  int level = 1;
  int lines = 0;
  bool isGameOver = false;
  bool isPaused = true;

  Timer? _gameTimer;
  int _dropSpeed = 1000;
  final Random _random = Random();

  GameController() {
    _initGame();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('highScore') ?? 0;
    notifyListeners();
  }

  Future<void> _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highScore', highScore);
  }

  void _initGame() {
    board = List.generate(height, (i) => List.filled(width, null));
    currentPiece = null;
    nextPiece = null;
    holdPiece = null;
    score = 0;
    level = 1;
    lines = 0;
    isGameOver = false;
    isPaused = true;
    canHold = true;

    nextPiece = _createRandomPiece();
    _spawnNewPiece();

    SoundService.playBackgroundMusic();
    notifyListeners();
  }

  void _startGameLoop() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(Duration(milliseconds: _dropSpeed), (timer) {
      if (!isPaused && !isGameOver) {
        moveDown();
      }
    });
  }

  void _spawnNewPiece() {
    if (nextPiece == null) {
      nextPiece = _createRandomPiece();
    }

    currentPiece = nextPiece;
    nextPiece = _createRandomPiece();

    final pieceWidth = currentPiece!.shape[0].length;
    final startX = (width / 2 - pieceWidth / 2).floor().toDouble();
    currentPiece!.position = Offset(startX, -1);

    if (_checkCollision(currentPiece!.position, currentPiece!.shape)) {
      _endGame();
      SoundService.playGameOver();
      SoundService.stopBackgroundMusic();
      return;
    }
    canHold = true;
    notifyListeners();
  }

  Piece _createRandomPiece() {
    final shapeIndex = _random.nextInt(Piece.shapes.length);
    return Piece(
      typeIndex: shapeIndex,
      shape: Piece.shapes[shapeIndex],
      color: Piece.colors[shapeIndex],
      position: Offset.zero,
    );
  }

  bool _checkCollision(Offset position, List<List<int>> shape) {
    for (int y = 0; y < shape.length; y++) {
      for (int x = 0; x < shape[y].length; x++) {
        if (shape[y][x] == 1) {
          int boardX = (position.dx + x).toInt();
          int boardY = (position.dy + y).toInt();

          if (boardX < 0 || boardX >= width || boardY >= height) {
            return true;
          }
          if (boardY >= 0 && board[boardY][boardX] != null) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void moveDown() {
    if (isPaused || isGameOver || currentPiece == null) return;

    final newPosition = currentPiece!.position + const Offset(0, 1);
    if (!_checkCollision(newPosition, currentPiece!.shape)) {
      currentPiece!.position = newPosition;
      SoundService.playMove();
      notifyListeners();
    } else {
      _lockPiece();
      _clearLines();
      _spawnNewPiece();
    }
  }

  void _lockPiece() {
    for (int y = 0; y < currentPiece!.shape.length; y++) {
      for (int x = 0; x < currentPiece!.shape[y].length; x++) {
        if (currentPiece!.shape[y][x] == 1) {
          int boardX = (currentPiece!.position.dx + x).toInt();
          int boardY = (currentPiece!.position.dy + y).toInt();

          if (boardY < 0) {
            _endGame();
            return;
          }
          if (boardY >= 0 && boardY < height) {
            board[boardY][boardX] = currentPiece!.color;
          }
        }
      }
    }
    SoundService.playPlace();
  }

  void _clearLines() {
    List<int> linesToClear = [];

    for (int y = height - 1; y >= 0; y--) {
      if (board[y].every((cell) => cell != null)) {
        linesToClear.add(y);
      }
    }

    if (linesToClear.isNotEmpty) {
      for (int line in linesToClear) {
        board.removeAt(line);
        board.insert(0, List.filled(width, null));
      }

      lines += linesToClear.length;
      level = (lines ~/ 10) + 1;
      score += _calculateScore(linesToClear.length, level);

      _dropSpeed = (1000 - (level - 1) * 100).clamp(100, 1000);
      _gameTimer?.cancel();
      _startGameLoop();

      SoundService.playClear();
      if (linesToClear.length > 1) {
        SoundService.playCollectPoint();
      }
      notifyListeners();
    }
  }

  int _calculateScore(int lines, int level) {
    const baseScores = [0, 40, 100, 300, 1200];
    return baseScores[lines] * level;
  }

  void moveLeft() {
    if (isPaused || isGameOver || currentPiece == null) return;

    final newPosition = currentPiece!.position + const Offset(-1, 0);
    if (!_checkCollision(newPosition, currentPiece!.shape)) {
      currentPiece!.position = newPosition;
      SoundService.playMove();
      notifyListeners();
    }
  }

  void moveRight() {
    if (isPaused || isGameOver || currentPiece == null) return;

    final newPosition = currentPiece!.position + const Offset(1, 0);
    if (!_checkCollision(newPosition, currentPiece!.shape)) {
      currentPiece!.position = newPosition;
      SoundService.playMove();
      notifyListeners();
    }
  }

  void rotate() {
    if (isPaused || isGameOver || currentPiece == null) return;

    final rotated = _rotatePiece(currentPiece!.shape);
    if (!_checkCollision(currentPiece!.position, rotated)) {
      currentPiece!.shape = rotated;
      SoundService.playRotate();
      notifyListeners();
    }
  }

  List<List<int>> _rotatePiece(List<List<int>> shape) {
    final rows = shape.length;
    final cols = shape[0].length;
    final rotated = List.generate(cols, (i) => List.filled(rows, 0));

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        rotated[c][rows - 1 - r] = shape[r][c];
      }
    }
    return rotated;
  }

  void hardDrop() {
    if (isPaused || isGameOver || currentPiece == null) return;

    while (!_checkCollision(currentPiece!.position + const Offset(0, 1), currentPiece!.shape)) {
      currentPiece!.position += const Offset(0, 1);
    }
    SoundService.playDrop();
    _lockPiece();
    _clearLines();
    _spawnNewPiece();
  }

  void hold() {
    if (isPaused || isGameOver || !canHold || currentPiece == null) return;

    if (holdPiece == null) {
      holdPiece = Piece(
        typeIndex: currentPiece!.typeIndex,
        shape: currentPiece!.shape,
        color: currentPiece!.color,
        position: Offset.zero,
      );
      _spawnNewPiece();
    } else {
      final temp = currentPiece;
      currentPiece = Piece(
        typeIndex: holdPiece!.typeIndex,
        shape: holdPiece!.shape,
        color: holdPiece!.color,
        position: currentPiece!.position,
      );
      holdPiece = Piece(
        typeIndex: temp!.typeIndex,
        shape: temp.shape,
        color: temp.color,
        position: Offset.zero,
      );
    }
    canHold = false;
    notifyListeners();
  }

  void togglePause() {
    if (isGameOver) return;

    isPaused = !isPaused;
    if (isPaused) {
      _gameTimer?.cancel();
      SoundService.stopBackgroundMusic();
    } else {
      _startGameLoop();
      SoundService.playBackgroundMusic();
    }
    notifyListeners();
  }

  void restart() {
    _gameTimer?.cancel();
    currentPiece = null;
    nextPiece = null;
    holdPiece = null;
    _initGame();
    SoundService.playBackgroundMusic();
    notifyListeners();
  }

  void _endGame() {
    isGameOver = true;
    _gameTimer?.cancel();
    if (score > highScore) {
      highScore = score;
      _saveHighScore();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    SoundService.dispose();
    super.dispose();
  }
}
