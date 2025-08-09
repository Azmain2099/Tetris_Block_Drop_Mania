import 'package:flutter/material.dart';
import 'package:notun/game_controller.dart';

class GameInfoPanel extends StatelessWidget {
  final GameController game;

  const GameInfoPanel({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem('SCORE', game.score),
          _buildStatItem('HIGH', game.highScore),
          _buildStatItem('LEVEL', game.level),
          _buildStatItem('LINES', game.lines),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.blueAccent,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}