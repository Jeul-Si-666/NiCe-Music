import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/song_model.dart';
import '../services/youtube_audio_service.dart';

const List<SongModel> kMockSongs = [
  SongModel(
    id: 'jfKfPfyJRdk',
    title: 'Midnight City',
    artist: 'M83',
    thumbnailUrl: 'https://picsum.photos/seed/midnight/600/600',
    duration: Duration(minutes: 4, seconds: 3),
  ),
  SongModel(
    id: '5qap5aO4i9A',
    title: 'Starboy',
    artist: 'The Weeknd, Daft Punk',
    thumbnailUrl: 'https://picsum.photos/seed/starboy/600/600',
    duration: Duration(minutes: 3, seconds: 50),
  ),
  SongModel(
    id: 'DWcJFNfaw9c',
    title: 'After Dark',
    artist: 'Mr.Kitty',
    thumbnailUrl: 'https://picsum.photos/seed/afterdark/600/600',
    duration: Duration(minutes: 4, seconds: 19),
  ),
  SongModel(
    id: '4xDzrJKXOOY',
    title: 'Blinding Lights',
    artist: 'The Weeknd',
    thumbnailUrl: 'https://picsum.photos/seed/blinding/600/600',
    duration: Duration(minutes: 3, seconds: 20),
  ),
  SongModel(
    id: 'rUxyKA_-grg',
    title: 'Instant Crush',
    artist: 'Daft Punk ft. Julian Casablancas',
    thumbnailUrl: 'https://picsum.photos/seed/crush/600/600',
    duration: Duration(minutes: 5, seconds: 37),
  ),
];

final youtubeAudioServiceProvider = Provider<YoutubeAudioService>((ref) {
  final service = YoutubeAudioService();
  ref.onDispose(service.dispose);
  return service;
});

final currentTabIndexProvider = StateProvider<int>((ref) => 0);

class SearchNotifier extends AsyncNotifier<List<SongModel>> {
  @override
  FutureOr<List<SongModel>> build() {
    return kMockSongs;
  }

  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      state = const AsyncData(kMockSongs);
      return;
    }

    state = const AsyncLoading();
    await Future<void>.delayed(const Duration(milliseconds: 600));

    // Allow testing the error state easily by typing "error" in the search bar.
    if (trimmed.toLowerCase() == 'error') {
      state = AsyncError(
        Exception('Unable to reach YouTube streams. Please try again.'),
        StackTrace.current,
      );
      return;
    }

    final results = kMockSongs.where((song) {
      final lowerQuery = trimmed.toLowerCase();
      return song.title.toLowerCase().contains(lowerQuery) ||
          song.artist.toLowerCase().contains(lowerQuery);
    }).toList();

    state = AsyncData(results);
  }
}

final searchResultsProvider =
    AsyncNotifierProvider<SearchNotifier, List<SongModel>>(SearchNotifier.new);

class PlaybackNotifier extends Notifier<PlaybackState> {
  @override
  PlaybackState build() {
    return PlaybackState(
      currentSong: kMockSongs.first,
      isPlaying: false,
      position: const Duration(minutes: 1, seconds: 24),
    );
  }

  Future<void> playSong(SongModel song) async {
    state = state.copyWith(
      currentSong: song,
      isPlaying: true,
      position: Duration.zero,
      isLoading: true,
    );

    try {
      final audioService = ref.read(youtubeAudioServiceProvider);
      final streamUri = await audioService.getAudioStreamUri(song.id);
      await audioService.player.setUrl(streamUri.toString());
      unawaited(audioService.player.play());
      state = state.copyWith(isLoading: false);
    } catch (_) {
      // Fallback to simulated UI playback when offline or when a mock ID is used.
      state = state.copyWith(isLoading: false, isPlaying: true);
    }
  }

  void togglePlayPause() {
    if (state.currentSong == null) return;
    final nextPlaying = !state.isPlaying;
    state = state.copyWith(isPlaying: nextPlaying);

    final player = ref.read(youtubeAudioServiceProvider).player;
    if (nextPlaying) {
      unawaited(player.play());
    } else {
      unawaited(player.pause());
    }
  }

  void seek(Duration newPosition) {
    final song = state.currentSong;
    if (song == null) return;

    final clampedSeconds = newPosition.inSeconds.clamp(0, song.duration.inSeconds);
    final target = Duration(seconds: clampedSeconds);
    state = state.copyWith(position: target);
    unawaited(ref.read(youtubeAudioServiceProvider).player.seek(target));
  }
}

final playbackProvider =
    NotifierProvider<PlaybackNotifier, PlaybackState>(PlaybackNotifier.new);
