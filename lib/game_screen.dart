import 'package:flutter/material.dart';
import 'package:notun/widgets/game_board.dart';
import 'package:notun/widgets/game_info_panel.dart';
import 'package:notun/widgets/preview_panel.dart';
import 'package:notun/widgets/control_panel.dart';
import 'package:provider/provider.dart';
import 'package:notun/game_controller.dart';
import 'package:notun/services/sound_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _showInstructions = true;
  bool _gameOverDialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await SoundService.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF121212), Color(0xFF1a1a2e)],
          ),
        ),
        child: SafeArea(
          child: ChangeNotifierProvider(
            create: (context) => GameController(),
            child: Consumer<GameController>(
              builder: (context, game, child) {
                // Show game over dialog once per game
                if (game.isGameOver && !_gameOverDialogShown) {
                  _gameOverDialogShown = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showGameOverDialog(context, game);
                  });
                }

                // Reset flag when game restarts
                if (!game.isGameOver) {
                  _gameOverDialogShown = false;
                }

                // Start background music when game begins
                if (!_showInstructions && game.score == 0 && !game.isPaused) {
                  SoundService.playBackgroundMusic();
                }

                // Show instructions before game starts
                if (_showInstructions && game.score == 0) {
                  return _buildInstructionsOverlay(game);
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      // Centered game title
                      _buildGameTitle(),
                      const SizedBox(height: 16),

                      // Game stats
                      GameInfoPanel(game: game),
                      const SizedBox(height: 16),

                      // Main game area
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hold piece panel
                            PreviewPanel(
                              title: 'HOLD',
                              piece: game.holdPiece,
                            ),

                            // Game board - now centered with proper constraints
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Container(
                                    constraints: BoxConstraints(
                                      maxWidth: constraints.maxHeight * 0.6,
                                    ),
                                    child: const GameBoard(),
                                  );
                                },
                              ),
                            ),

                            // Next piece panel
                            PreviewPanel(
                              title: 'NEXT',
                              piece: game.nextPiece,
                            ),
                          ],
                        ),
                      ),

                      // Controls at bottom
                      const SizedBox(height: 16),
                      ControlPanel(game: game),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameTitle() {
    return const Column(
      children: [
        Text(
          'BLOCK DROP',
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
        Text(
          'MANIA',
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionsOverlay(GameController game) {
    return Container(
      color: Colors.black.withOpacity(0.9),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Centered title with professional styling
          const Column(
            children: [
              Text(
                'BLOCK DROP',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              Text(
                'MANIA',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'HOW TO PLAY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildInstructionItem(Icons.arrow_back, 'Move Left'),
          _buildInstructionItem(Icons.arrow_forward, 'Move Right'),
          _buildInstructionItem(Icons.arrow_upward, 'Rotate Piece'),
          _buildInstructionItem(Icons.vertical_align_bottom, 'Hard Drop'),
          _buildInstructionItem(Icons.swap_horiz, 'Hold Piece'),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              setState(() => _showInstructions = false);
              game.togglePause();
              SoundService.playBackgroundMusic();
            },
            child: const Text(
              'START GAME',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          _buildSoundControls(),
        ],
      ),
    );
  }

  Widget _buildSoundControls() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSoundToggleButton(
            icon: Icons.music_note,
            onPressed: () => SoundService.toggleMusic(!SoundService.musicEnabled),
          ),
          const SizedBox(width: 20),
          _buildSoundToggleButton(
            icon: Icons.volume_up,
            onPressed: () => SoundService.toggleSounds(!SoundService.soundsEnabled),
          ),
        ],
      ),
    );
  }

  Widget _buildSoundToggleButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, size: 30, color: Colors.blueAccent),
      onPressed: onPressed,
    );
  }

  Widget _buildInstructionItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 30),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  void _showGameOverDialog(BuildContext context, GameController game) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        title: const Column(
          children: [
            Text(
              'BLOCK DROP',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'MANIA',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'GAME OVER',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Score: ${game.score}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'High Score: ${game.highScore}',
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            if (game.score == game.highScore && game.score > 0)
              const Text(
                'NEW HIGH SCORE!',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              game.restart();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'PLAY AGAIN',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}