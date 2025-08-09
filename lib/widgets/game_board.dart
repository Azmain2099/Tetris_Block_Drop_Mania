import 'package:flutter/material.dart';
import 'package:notun/game_controller.dart';
import 'package:notun/models/piece.dart';
import 'package:provider/provider.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: GameController.width / GameController.height,
      child: Consumer<GameController>(
        builder: (context, game, child) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blueGrey.shade800, width: 2),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cellSize = constraints.maxWidth / GameController.width;
                return Stack(
                  children: [
                    _buildGrid(cellSize),
                    if (!game.isGameOver) ..._buildBoardCells(game, cellSize),
                    if (!game.isGameOver) ..._buildCurrentPiece(game, cellSize),
                    if (game.isPaused) _buildPauseOverlay(),
                    if (game.isGameOver) _buildGameOverOverlay(game),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrid(double cellSize) {
    return Column(
      children: List.generate(GameController.height, (y) {
        return Row(
          children: List.generate(GameController.width, (x) {
            return Container(
              width: cellSize,
              height: cellSize,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blueGrey.withOpacity(0.1),
                  width: 0.5,
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  List<Widget> _buildBoardCells(GameController game, double cellSize) {
    List<Widget> cells = [];
    for (int y = 0; y < GameController.height; y++) {
      for (int x = 0; x < GameController.width; x++) {
        if (game.board[y][x] != null) {
          cells.add(
            Positioned(
              left: x * cellSize,
              top: y * cellSize,
              child: _buildBlock(cellSize, game.board[y][x]!),
            ),
          );
        }
      }
    }
    return cells;
  }

  List<Widget> _buildCurrentPiece(GameController game, double cellSize) {
    if (game.currentPiece == null) return [];
    List<Widget> pieces = [];
    final piece = game.currentPiece!;

    for (int y = 0; y < piece.shape.length; y++) {
      for (int x = 0; x < piece.shape[y].length; x++) {
        if (piece.shape[y][x] == 1) {
          final boardX = piece.position.dx.toInt() + x;
          final boardY = piece.position.dy.toInt() + y;
          if (boardY >= 0) {
            pieces.add(
              Positioned(
                left: boardX * cellSize,
                top: boardY * cellSize,
                child: _buildBlock(cellSize, piece.color, piece.icon),
              ),
            );
          }
        }
      }
    }
    return pieces;
  }

  Widget _buildBlock(double size, Color color, [IconData? icon]) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 4,
            spreadRadius: 1,
          )
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: icon != null
          ? Icon(icon, color: Colors.white.withOpacity(0.8), size: size * 0.6)
          : null,
    );
  }

  Widget _buildPauseOverlay() => Container(
    color: Colors.black.withOpacity(0.7),
    child: const Center(
      child: Text(
        'PAUSED',
        style: TextStyle(
          color: Colors.blueAccent,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  Widget _buildGameOverOverlay(GameController game) => Container(
    color: Colors.black.withOpacity(0.7),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'GAME OVER',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Score: ${game.score}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'High Score: ${game.highScore}',
            style: const TextStyle(
              color: Colors.blueAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            onPressed: game.restart,
            child: const Text(
              'PLAY AGAIN',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ),
  );
}
