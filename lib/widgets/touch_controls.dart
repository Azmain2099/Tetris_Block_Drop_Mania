import 'package:flutter/material.dart';
import 'package:notun/game_controller.dart';
import 'package:provider/provider.dart';

class TouchControls extends StatelessWidget {
  const TouchControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      child: Stack(
        children: [
          // Directional pad
          Center(
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.3),
                border: Border.all(color: Colors.blueAccent, width: 2),
              ),
              child: Stack(
                children: [
                  // Up (Rotate)
                  Positioned(
                    top: 10,
                    left: 75,
                    child: _buildControlButton(
                      onTap: () => Provider.of<GameController>(context, listen: false).rotate(),
                      icon: Icons.arrow_upward,
                    ),
                  ),
                  // Left
                  Positioned(
                    top: 75,
                    left: 10,
                    child: _buildControlButton(
                      onTap: () => Provider.of<GameController>(context, listen: false).moveLeft(),
                      icon: Icons.arrow_back,
                    ),
                  ),
                  // Down
                  Positioned(
                    top: 140,
                    left: 75,
                    child: _buildControlButton(
                      onTap: () => Provider.of<GameController>(context, listen: false).moveDown(),
                      icon: Icons.arrow_downward,
                    ),
                  ),
                  // Right
                  Positioned(
                    top: 75,
                    right: 10,
                    child: _buildControlButton(
                      onTap: () => Provider.of<GameController>(context, listen: false).moveRight(),
                      icon: Icons.arrow_forward,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action buttons
          Positioned(
            right: 20,
            top: 30,
            child: Column(
              children: [
                _buildActionButton(
                  onTap: () => Provider.of<GameController>(context, listen: false).hold(),
                  icon: Icons.swap_horiz,
                  label: 'Hold',
                ),
                const SizedBox(height: 20),
                _buildActionButton(
                  onTap: () => Provider.of<GameController>(context, listen: false).hardDrop(),
                  icon: Icons.vertical_align_bottom,
                  label: 'Drop',
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.7),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.5),
              blurRadius: 8,
              spreadRadius: 2,
            )
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
    Color color = Colors.amber,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}