import 'package:flutter/material.dart';
import 'package:notun/game_controller.dart';
import 'package:provider/provider.dart';

class GameControls extends StatelessWidget {
  const GameControls({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameController>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(
          icon: Icons.refresh,
          label: 'Restart',
          onPressed: game.restart,
          color: Colors.blueAccent,
        ),
        _buildControlButton(
          icon: Icons.play_arrow,
          label: 'New Game',
          onPressed: game.restart,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 8,
                spreadRadius: 2,
              )
            ],
          ),
          child: IconButton(
            icon: Icon(icon, size: 24),
            color: Colors.white,
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}