import 'package:just_audio/just_audio.dart';

class SoundService {
  static const String _clickSoundPath = 'assets/sounds/click.mp3';
  final AudioPlayer _player = AudioPlayer();

  Future<void> playClickSound() async {
    try {
      await _player.setAsset(_clickSoundPath);
      await _player.play();
    } catch (e) {
      print('Sound error: $e');
    }
  }

  void dispose() {
    _player.dispose();
  }
}
