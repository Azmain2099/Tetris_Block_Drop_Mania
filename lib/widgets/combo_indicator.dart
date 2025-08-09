import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notun/game_controller.dart';

class ComboIndicator extends StatelessWidget {
  const ComboIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameController>(context);

    // Only show for 2+ combos
    if (game.comboCount < 2) return const SizedBox.shrink();

    return AnimatedOpacity(
      opacity: game.comboCount > 1 ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              '${game.comboCount}x COMBO!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.star, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
