import 'package:audioplayers/audioplayers.dart';

class MusicService {
  static final MusicService _instance = MusicService._internal();
  factory MusicService() => _instance;
  MusicService._internal();

  final AudioPlayer _player = AudioPlayer();

  Future<void> playMusic() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(
      AssetSource("music.mp3"),
      volume: 1.0,
    );
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  Future<void> stopMusic() async {
    await _player.stop();
  }
}
