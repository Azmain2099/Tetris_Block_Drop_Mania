import 'package:flutter/material.dart';
import 'package:notun/models/piece.dart';

class PreviewPanel extends StatelessWidget {
  final String title;
  final Piece? piece;

  const PreviewPanel({super.key, required this.title, this.piece});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: piece != null
                ? _buildPiecePreview(piece!)
                : const SizedBox(height: 60),
          ),
        ],
      ),
    );
  }

  Widget _buildPiecePreview(Piece piece) {
    final gridSize = piece.shape.length > 3 ? 4 : 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridSize,
        childAspectRatio: 1,
      ),
      itemCount: gridSize * gridSize,
      itemBuilder: (context, index) {
        final row = index ~/ gridSize;
        final col = index % gridSize;
        final isFilled = row < piece.shape.length &&
            col < piece.shape[0].length &&
            piece.shape[row][col] == 1;

        return Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isFilled ? piece.color : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }
}