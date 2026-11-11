class SongModel {
  final String id;
  final String title;
  final String artist;
  final String thumbnailUrl;
  final Duration duration;

  const SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.thumbnailUrl,
    required this.duration,
  });
}

class PlaybackState {
  final SongModel? currentSong;
  final bool isPlaying;
  final Duration position;
  final bool isLoading;

  const PlaybackState({
    this.currentSong,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.isLoading = false,
  });

  PlaybackState copyWith({
    SongModel? currentSong,
    bool? isPlaying,
    Duration? position,
    bool? isLoading,
  }) {
    return PlaybackState(
      currentSong: currentSong ?? this.currentSong,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
