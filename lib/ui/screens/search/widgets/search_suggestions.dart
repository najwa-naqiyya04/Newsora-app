import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/search_provider.dart';

/// Data satu topik populer: nama, ikon dekorasi, warna gradasi,
/// dan (opsional) gambar latar dari assets.
class _Topic {
  const _Topic({
    required this.name,
    required this.icon,
    required this.colors,
    this.imageAsset,
  });

  final String name;
  final IconData icon;
  final List<Color> colors;

  /// Isi dengan path gambar (mis. 'assets/topics/space.jpg') kalau mau
  /// memakai foto sebagai latar. Kalau null, dipakai gradasi warna.
  final String? imageAsset;
}

class SearchSuggestions extends ConsumerWidget {
  const SearchSuggestions({super.key});

  static const _topics = [
    _Topic(
      name: 'Artificial Intelligence',
      icon: Icons.psychology_rounded,
      colors: [Color(0xFF3B2F8F), Color(0xFF7C4DFF)],
    ),
    _Topic(
      name: 'Climate',
      icon: Icons.eco_rounded,
      colors: [Color(0xFF0B5D4B), Color(0xFF3DBE8B)],
    ),
    _Topic(
      name: 'Economy',
      icon: Icons.account_balance_rounded,
      colors: [Color(0xFF8A4B00), Color(0xFFF2A33A)],
    ),
    _Topic(
      name: 'Football',
      icon: Icons.sports_soccer_rounded,
      colors: [Color(0xFF14532D), Color(0xFF84CC16)],
    ),
    _Topic(
      name: 'Space',
      icon: Icons.rocket_launch_rounded,
      colors: [Color(0xFF0B1030), Color(0xFF4C3A9E)],
    ),
    _Topic(
      name: 'Startup',
      icon: Icons.lightbulb_rounded,
      colors: [Color(0xFFB4236B), Color(0xFFFF8A4C)],
    ),
    _Topic(
      name: 'Health',
      icon: Icons.favorite_rounded,
      colors: [Color(0xFF9F1239), Color(0xFFFB7185)],
    ),
    _Topic(
      name: 'Election',
      icon: Icons.how_to_vote_rounded,
      colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Topik populer', style: theme.textTheme.titleSmall),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final topic in _topics)
              _TopicPill(
                topic: topic,
                onTap: () {
                  ref.read(SearchQueryProvider.notifier).submit(topic.name);
                },
              ),
          ],
        ),
      ],
    );
  }
}

/// Kartu topik berbentuk kapsul dengan latar gradasi/gambar dan teks tebal.
class _TopicPill extends StatefulWidget {
  const _TopicPill({required this.topic, required this.onTap});

  final _Topic topic;
  final VoidCallback onTap;

  @override
  State<_TopicPill> createState() => _TopicPillState();
}

class _TopicPillState extends State<_TopicPill> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final topic = widget.topic;
    final radius = BorderRadius.circular(40);

    return AnimatedScale(
      scale: _pressed ? 0.96 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: topic.colors,
            ),
          ),
          child: InkWell(
            borderRadius: radius,
            onTap: widget.onTap,
            onHighlightChanged: (value) => setState(() => _pressed = value),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Gambar latar (opsional).
                if (topic.imageAsset != null)
                  Image.asset(
                    topic.imageAsset!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                // Ikon besar samar sebagai dekorasi.
                Positioned(
                  right: -6,
                  bottom: -14,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: Icon(
                      topic.icon,
                      size: 72,
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                ),
                // Lapisan gelap tipis supaya teks putih selalu terbaca.
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.05),
                        Colors.black.withValues(alpha: 0.25),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      topic.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        height: 1.15,
                        shadows: [
                          Shadow(color: Colors.black38, blurRadius: 6),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}