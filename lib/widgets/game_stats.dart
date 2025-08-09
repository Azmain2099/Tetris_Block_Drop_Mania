// game_stats.dart
import 'package:flutter/material.dart';
import 'package:notun/game_controller.dart';
import 'package:provider/provider.dart';

class GameStats extends StatelessWidget {
  const GameStats({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameController>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildStatItem('SCORE', game.score.toString()),
          const SizedBox(height: 8),
          _buildStatItem('LEVEL', game.level.toString()),
          const SizedBox(height: 8),
          _buildStatItem('LINES', game.lines.toString()),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.blueAccent,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}