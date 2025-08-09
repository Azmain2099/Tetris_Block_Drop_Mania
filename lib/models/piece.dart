import 'package:flutter/material.dart';

class Piece {
  static const List<List<List<int>>> shapes = [
    // I
    [
      [0, 0, 0, 0],
      [1, 1, 1, 1],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
    ],
    // J
    [
      [1, 0, 0],
      [1, 1, 1],
      [0, 0, 0],
    ],
    // L
    [
      [0, 0, 1],
      [1, 1, 1],
      [0, 0, 0],
    ],
    // O
    [
      [1, 1],
      [1, 1],
    ],
    // S
    [
      [0, 1, 1],
      [1, 1, 0],
      [0, 0, 0],
    ],
    // T
    [
      [0, 1, 0],
      [1, 1, 1],
      [0, 0, 0],
    ],
    // Z
    [
      [1, 1, 0],
      [0, 1, 1],
      [0, 0, 0],
    ],
  ];

  static const List<Color> colors = [
    Color(0xFF66FFFF), // Cyan
    Color(0xFF4169E1), // Royal Blue
    Color(0xFFFFD700), // Gold
    Color(0xFF32CD32), // Lime Green
    Color(0xFF9370DB), // Purple
    Color(0xFFFF6347), // Tomato
    Color(0xFFFF69B4), // Hot Pink
  ];

  static const List<IconData> icons = [
    Icons.ac_unit,
    Icons.water_drop,
    Icons.star,
    Icons.grass,
    Icons.auto_awesome,
    Icons.local_fire_department,
    Icons.bolt,
  ];

  List<List<int>> shape;
  Color color;
  Offset position;
  int typeIndex;
  IconData icon;

  Piece({
    required this.typeIndex,
    required this.shape,
    required this.color,
    required this.position,
  }) : icon = icons[typeIndex];
}