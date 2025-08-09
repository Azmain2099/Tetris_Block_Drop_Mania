// next_piece.dart
import 'package:flutter/material.dart';
import 'package:notun/game_controller.dart';
import 'package:notun/models/piece.dart';
import 'package:provider/provider.dart';

class NextPiece extends StatelessWidget {
  const NextPiece({super.key});

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
          const Text(
            'NEXT',
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          if (game.nextPiece != null)
            _buildPiecePreview(game.nextPiece!),
        ],
      ),
    );
  }

  Widget _buildPiecePreview(Piece piece) {
    return Center(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: piece.shape[0].length,
          childAspectRatio: 1,
        ),
        itemCount: piece.shape.length * piece.shape[0].length,
        itemBuilder: (context, index) {
          final row = index ~/ piece.shape[0].length;
          final col = index % piece.shape[0].length;

          return Container(
            decoration: BoxDecoration(
              color: piece.shape[row][col] == 1 ? piece.color : Colors.transparent,
              border: Border.all(
                color: Colors.grey[800]!,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        },
      ),
    );
  }
}