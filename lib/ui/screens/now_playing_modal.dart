import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/song_model.dart';
import '../../providers/music_providers.dart';
import '../widgets/glass_container.dart';

class NowPlayingModal extends ConsumerWidget {
  const NowPlayingModal({super.key});

  String _formatDuration(Duration duration) {
    final String minutes = duration.inMinutes.toString();
    final String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PlaybackState playback = ref.watch(playbackProvider);
    final SongModel? song = playback.currentSong;

    if (song == null) return const SizedBox.shrink();

    final double maxSeconds = song.duration.inSeconds.toDouble();
    final double currentSeconds =
        playback.position.inSeconds.toDouble().clamp(0.0, maxSeconds);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Deeply blurred album artwork background
          Image.network(
            song.thumbnailUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A3A2A), Color(0xFF0F0F0F)],
                ),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 80.0),
            child: Container(
              color: Colors.black.withValues(alpha: 0.65),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ModalTopBar(onClose: () => Navigator.of(context).pop()),
                  const Spacer(),
                  _AlbumArtCover(thumbnailUrl: song.thumbnailUrl),
                  const Spacer(),
                  Text(
                    song.title,
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    song.artist,
                    style: const TextStyle(
                      color: Color(0xFFB3B3B3),
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 24.0),
                  _TrackProgressSlider(
                    currentSeconds: currentSeconds,
                    maxSeconds: maxSeconds,
                    formattedPosition: _formatDuration(playback.position),
                    formattedDuration: _formatDuration(song.duration),
                    onChanged: (double value) {
                      ref
                          .read(playbackProvider.notifier)
                          .seek(Duration(seconds: value.toInt()));
                    },
                  ),
                  const SizedBox(height: 24.0),
                  _PlaybackControls(
                    isPlaying: playback.isPlaying,
                    onPlayPause: () =>
                        ref.read(playbackProvider.notifier).togglePlayPause(),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModalTopBar extends StatelessWidget {
  final VoidCallback onClose;

  const _ModalTopBar({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onClose,
          child: const Icon(
            CupertinoIcons.chevron_down,
            color: Color(0xFFFFFFFF),
            size: 26.0,
          ),
        ),
        const Text(
          'NOW PLAYING',
          style: TextStyle(
            color: Color(0xFFB3B3B3),
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(width: 26.0),
      ],
    );
  }
}

class _AlbumArtCover extends StatelessWidget {
  final String thumbnailUrl;

  const _AlbumArtCover({required this.thumbnailUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.55),
                blurRadius: 36.0,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.0),
            child: Image.network(
              thumbnailUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF1E1E1E),
                child: const Icon(
                  CupertinoIcons.music_note_2,
                  color: Color(0xFFB3B3B3),
                  size: 72.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TrackProgressSlider extends StatelessWidget {
  final double currentSeconds;
  final double maxSeconds;
  final String formattedPosition;
  final String formattedDuration;
  final ValueChanged<double> onChanged;

  const _TrackProgressSlider({
    required this.currentSeconds,
    required this.maxSeconds,
    required this.formattedPosition,
    required this.formattedDuration,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
            activeTrackColor: const Color(0xFF1DB954),
            inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
            thumbColor: const Color(0xFFFFFFFF),
          ),
          child: Slider(
            value: currentSeconds,
            max: maxSeconds > 0 ? maxSeconds : 1.0,
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedPosition,
                style: const TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontSize: 12.0,
                ),
              ),
              Text(
                formattedDuration,
                style: const TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlaybackControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;

  const _PlaybackControls({
    required this.isPlaying,
    required this.onPlayPause,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 40.0,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      color: Colors.white.withValues(alpha: 0.06),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: const Icon(
              CupertinoIcons.shuffle,
              color: Color(0xFFB3B3B3),
              size: 22.0,
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: const Icon(
              CupertinoIcons.backward_fill,
              color: Color(0xFFFFFFFF),
              size: 30.0,
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onPlayPause,
            child: Container(
              width: 68.0,
              height: 68.0,
              decoration: BoxDecoration(
                color: const Color(0xFF1DB954),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1DB954).withValues(alpha: 0.4),
                    blurRadius: 20.0,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
                color: const Color(0xFF0F0F0F),
                size: 32.0,
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: const Icon(
              CupertinoIcons.forward_fill,
              color: Color(0xFFFFFFFF),
              size: 30.0,
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: const Icon(
              CupertinoIcons.repeat,
              color: Color(0xFFB3B3B3),
              size: 22.0,
            ),
          ),
        ],
      ),
    );
  }
}
