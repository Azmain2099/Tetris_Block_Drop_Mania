import 'package:flutter/material.dart';
import 'package:notun/game_controller.dart';
import 'package:notun/services/sound_service.dart';

class ControlPanel extends StatefulWidget {
  final GameController game;

  const ControlPanel({super.key, required this.game});

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  // Track current sound and music states to update UI
  late bool musicEnabled;
  late bool soundsEnabled;

  @override
  void initState() {
    super.initState();
    musicEnabled = SoundService.musicEnabled;
    soundsEnabled = SoundService.soundsEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Directional controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildControlButton(
              icon: Icons.arrow_back,
              onPressed: widget.game.moveLeft,
            ),
            const SizedBox(width: 12),
            _buildControlButton(
              icon: Icons.arrow_upward,
              onPressed: widget.game.rotate,
            ),
            const SizedBox(width: 12),
            _buildControlButton(
              icon: Icons.arrow_forward,
              onPressed: widget.game.moveRight,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionButton(
              icon: Icons.swap_horiz,
              label: 'HOLD',
              onPressed: widget.game.hold,
            ),
            const SizedBox(width: 24),
            _buildActionButton(
              icon: Icons.vertical_align_bottom,
              label: 'DROP',
              onPressed: widget.game.hardDrop,
            ),
            const SizedBox(width: 24),
            _buildActionButton(
              icon: widget.game.isPaused ? Icons.play_arrow : Icons.pause,
              label: widget.game.isPaused ? 'RESUME' : 'PAUSE',
              onPressed: widget.game.togglePause,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Sound controls
        _buildSoundControls(),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.7),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 2,
            )
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.blueAccent),
          ),
          child: IconButton(
            icon: Icon(icon, size: 24),
            color: Colors.blueAccent,
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.blueAccent,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSoundControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSoundButton(
          icon: Icons.music_note,
          label: 'MUSIC',
          iconColor: musicEnabled ? Colors.blueAccent : Colors.grey,
          onPressed: () async {
            await SoundService.toggleMusic(!musicEnabled);
            setState(() {
              musicEnabled = SoundService.musicEnabled;
            });
          },
        ),
        const SizedBox(width: 20),
        _buildSoundButton(
          icon: Icons.volume_up,
          label: 'SFX',
          iconColor: soundsEnabled ? Colors.blueAccent : Colors.grey,
          onPressed: () {
            SoundService.toggleSounds(!soundsEnabled);
            setState(() {
              soundsEnabled = SoundService.soundsEnabled;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSoundButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color iconColor = Colors.blueAccent,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blueAccent),
          ),
          child: IconButton(
            icon: Icon(icon, size: 20),
            color: iconColor,
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.blueAccent,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
