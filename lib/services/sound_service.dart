import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _sfxPlayer = AudioPlayer();
  static final AudioPlayer _bgmPlayer = AudioPlayer();

  static bool _soundsEnabled = true;
  static bool _musicEnabled = true;

  /// Getter for music enabled state
  static bool get musicEnabled => _musicEnabled;

  /// Getter for sounds enabled state
  static bool get soundsEnabled => _soundsEnabled;

  /// Initialize background music player with loop mode
  static Future<void> init() async {
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }

  /// Toggle sound effects on/off
  static void toggleSounds(bool enabled) {
    _soundsEnabled = enabled;
  }

  /// Toggle background music on/off
  static Future<void> toggleMusic(bool enabled) async {
    _musicEnabled = enabled;
    if (!enabled) {
      await _bgmPlayer.pause();
    } else {
      await playBackgroundMusic();
    }
  }

  /// Play the background music if enabled
  static Future<void> playBackgroundMusic() async {
    if (!_musicEnabled) return;
    await _bgmPlayer.play(AssetSource('sounds/background.mp3'));
  }

  /// Internal method to play sound effects if enabled
  static Future<void> _playSfx(String file) async {
    if (!_soundsEnabled) return;
    await _sfxPlayer.play(AssetSource(file));
  }

  // Public methods to play individual sound effects
  static Future<void> playMove() => _playSfx('sounds/move.mp3');
  static Future<void> playRotate() => _playSfx('sounds/rotate.mp3');
  static Future<void> playDrop() => _playSfx('sounds/drop.mp3');
  static Future<void> playPlace() => _playSfx('sounds/place.mp3');
  static Future<void> playClear() => _playSfx('sounds/clear.mp3');
  static Future<void> playGameOver() => _playSfx('sounds/game_over.mp3');
  static Future<void> playCollectPoint() => _playSfx('sounds/collect_point.mp3');

  /// Stop background music
  static Future<void> stopBackgroundMusic() async {
    await _bgmPlayer.pause();
  }

  /// Dispose audio players when no longer needed
  static void dispose() {
    _sfxPlayer.dispose();
    _bgmPlayer.dispose();
  }
}
