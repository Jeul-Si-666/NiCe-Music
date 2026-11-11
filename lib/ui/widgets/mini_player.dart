import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/song_model.dart';
import '../../providers/music_providers.dart';
import '../screens/now_playing_modal.dart';
import 'glass_container.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  void _openNowPlayingModal(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => const NowPlayingModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PlaybackState playback = ref.watch(playbackProvider);
    final SongModel? song = playback.currentSong;

    if (song == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => _openNowPlayingModal(context),
      child: GlassContainer(
        height: 68.0,
        borderRadius: 20.0,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        color: Colors.black.withValues(alpha: 0.35),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                song.thumbnailUrl,
                width: 46.0,
                height: 46.0,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 46.0,
                  height: 46.0,
                  color: const Color(0xFF1E1E1E),
                  child: const Icon(
                    CupertinoIcons.music_note,
                    color: Color(0xFFB3B3B3),
                    size: 20.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    song.artist,
                    style: const TextStyle(
                      color: Color(0xFFB3B3B3),
                      fontSize: 13.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () =>
                  ref.read(playbackProvider.notifier).togglePlayPause(),
              child: Container(
                width: 38.0,
                height: 38.0,
                decoration: const BoxDecoration(
                  color: Color(0xFF1DB954),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  playback.isPlaying
                      ? CupertinoIcons.pause_fill
                      : CupertinoIcons.play_fill,
                  color: const Color(0xFF0F0F0F),
                  size: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
