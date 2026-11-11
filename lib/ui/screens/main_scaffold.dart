import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/music_providers.dart';
import '../widgets/glass_container.dart';
import '../widgets/mini_player.dart';
import 'search_page.dart';

class MainScaffold extends ConsumerWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentIndex = ref.watch(currentTabIndexProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _MeshGlowBackground(),
          IndexedStack(
            index: currentIndex,
            children: const [
              SearchPage(),
              _LibraryPlaceholderPage(),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 18.0,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MiniPlayer(),
                  const SizedBox(height: 12.0),
                  _GlassBottomNavBar(
                    currentIndex: currentIndex,
                    onTap: (int index) {
                      ref.read(currentTabIndexProvider.notifier).state = index;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MeshGlowBackground extends StatelessWidget {
  const _MeshGlowBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: const Color(0xFF0F0F0F)),
        // Top-left subtle Spotify green radial glow
        Positioned(
          top: -120,
          left: -100,
          child: Container(
            width: 380,
            height: 380,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF1DB954).withValues(alpha: 0.22),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Bottom-right subtle deep blue radial glow
        Positioned(
          bottom: 40,
          right: -120,
          child: Container(
            width: 420,
            height: 420,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF1E3A8A).withValues(alpha: 0.24),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _GlassBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      height: 64.0,
      borderRadius: 24.0,
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      color: Colors.black.withValues(alpha: 0.4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavBarItem(
            icon: CupertinoIcons.search,
            label: 'Search',
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavBarItem(
            icon: CupertinoIcons.music_albums_fill,
            label: 'Library',
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor =
        isSelected ? const Color(0xFF1DB954) : const Color(0xFFB3B3B3);

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: activeColor, size: 22.0),
          const SizedBox(height: 4.0),
          Text(
            label,
            style: TextStyle(
              color: activeColor,
              fontSize: 11.0,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _LibraryPlaceholderPage extends StatelessWidget {
  const _LibraryPlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 180.0),
        children: const [
          Text(
            'Library',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 34.0,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          SizedBox(height: 24.0),
          GlassContainer(
            padding: EdgeInsets.all(24.0),
            child: Column(
              children: [
                Icon(
                  CupertinoIcons.music_albums,
                  color: Color(0xFFB3B3B3),
                  size: 40.0,
                ),
                SizedBox(height: 12.0),
                Text(
                  'Your saved tracks and playlists will appear here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFB3B3B3),
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
