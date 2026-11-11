import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/song_model.dart';
import '../../providers/music_providers.dart';
import '../widgets/glass_container.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<SongModel>> searchAsync =
        ref.watch(searchResultsProvider);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            const Text(
              'Search',
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 34.0,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 16.0),
            _GlassSearchBar(
              onChanged: (String query) {
                ref.read(searchResultsProvider.notifier).search(query);
              },
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: searchAsync.when(
                loading: () => const Center(
                  child: CupertinoActivityIndicator(
                    radius: 14.0,
                    color: Color(0xFF1DB954),
                  ),
                ),
                error: (Object error, StackTrace _) => Center(
                  child: GlassContainer(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          CupertinoIcons.exclamationmark_triangle,
                          color: Colors.redAccent,
                          size: 32.0,
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFB3B3B3),
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (List<SongModel> songs) {
                  if (songs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No songs found.',
                        style: TextStyle(
                          color: Color(0xFFB3B3B3),
                          fontSize: 16.0,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    padding: const EdgeInsets.only(bottom: 180.0),
                    itemCount: songs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final SongModel song = songs[index];
                      return _SongResultTile(song: song);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _GlassSearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 14.0,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
      color: Colors.white.withValues(alpha: 0.06),
      child: CupertinoSearchTextField(
        backgroundColor: Colors.transparent,
        placeholder: 'Songs, artists, or type "error"...',
        placeholderStyle: const TextStyle(
          color: Color(0xFFB3B3B3),
          fontSize: 15.0,
        ),
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 15.0,
        ),
        itemColor: const Color(0xFFB3B3B3),
        onChanged: onChanged,
      ),
    );
  }
}

class _SongResultTile extends ConsumerWidget {
  final SongModel song;

  const _SongResultTile({required this.song});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SongModel? currentSong = ref.watch(playbackProvider).currentSong;
    final bool isSelected = currentSong?.id == song.id;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: () => ref.read(playbackProvider.notifier).playSong(song),
        child: GlassContainer(
          borderRadius: 16.0,
          padding: const EdgeInsets.all(10.0),
          color: isSelected
              ? const Color(0xFF1DB954).withValues(alpha: 0.14)
              : Colors.white.withValues(alpha: 0.04),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  song.thumbnailUrl,
                  width: 54.0,
                  height: 54.0,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 54.0,
                    height: 54.0,
                    color: const Color(0xFF1E1E1E),
                    child: const Icon(
                      CupertinoIcons.music_note,
                      color: Color(0xFFB3B3B3),
                      size: 22.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFF1DB954)
                            : const Color(0xFFFFFFFF),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
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
              const Icon(
                CupertinoIcons.ellipsis,
                color: Color(0xFFB3B3B3),
                size: 20.0,
              ),
              const SizedBox(width: 6.0),
            ],
          ),
        ),
      ),
    );
  }
}
