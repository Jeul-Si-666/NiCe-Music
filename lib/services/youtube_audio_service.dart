import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeAudioService {
  final YoutubeExplode _yt = YoutubeExplode();
  final AudioPlayer player = AudioPlayer();

  Future<Uri> getAudioStreamUri(String videoId) async {
    // Request audio-only streams to avoid unnecessary video bandwidth overhead.
    final StreamManifest manifest = await _yt.videos.streamsClient.getManifest(videoId);
    final AudioOnlyStreamInfo streamInfo = manifest.audioOnly.withHighestBitrate();
    return streamInfo.url;
  }

  void dispose() {
    _yt.close();
    player.dispose();
  }
}
