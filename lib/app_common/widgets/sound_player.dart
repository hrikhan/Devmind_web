import 'package:audioplayers/audioplayers.dart';

class SoundPlayer {
  SoundPlayer._();

  static final AudioPlayer _player = AudioPlayer()
    ..setReleaseMode(ReleaseMode.stop)
    ..setVolume(0.6);

  static Future<void> playClick() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('assets/sounds/mouse-clicks-6849.mp3'));
    } catch (_) {
      // Silently ignore when the asset is not yet available.
    }
  }
}
