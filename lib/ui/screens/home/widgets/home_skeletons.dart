import 'package:flutter/material.dart';

/// Efek berdenyut untuk semua skeleton.
class _Pulse extends StatefulWidget {
  const _Pulse({required this.child});

  final Widget child;

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  late final Animation<double> _opacity = _controller.drive(
    Tween(begin: 0.45, end: 1.0),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      FadeTransition(opacity: _opacity, child: widget.child);
}

class _Block extends StatelessWidget {
  const _Block({this.width = double.infinity, required this.height, this.radius = 8});

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Skeleton untuk kartu berita besar.
class FeaturedSkeleton extends StatelessWidget {
  const FeaturedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Pulse(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: AspectRatio(
          aspectRatio: 0.92,
          child: _Block(height: double.infinity, radius: 32),
        ),
      ),
    );
  }
}

/// Skeleton untuk daftar kartu kecil.
class TileListSkeleton extends StatelessWidget {
  const TileListSkeleton({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return _Pulse(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: Column(
          children: List.generate(
            itemCount,
            (_) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: scheme.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Block(width: 88, height: 88, radius: 16),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Block(width: 70, height: 10),
                        SizedBox(height: 10),
                        _Block(height: 14),
                        SizedBox(height: 6),
                        _Block(width: 140, height: 14),
                        SizedBox(height: 10),
                        _Block(width: 60, height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}