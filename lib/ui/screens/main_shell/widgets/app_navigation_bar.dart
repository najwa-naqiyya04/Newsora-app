import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/bookmark_provider.dart';

// ---- Ukuran (silakan diutak-atik) ----
const double _overhang = 30; // tinggi area bubble yang menonjol di atas bar
const double _barHeight = 74; // tinggi bar putih
const double _bubbleRadius = 26; // jari-jari bubble
const double _bubbleDy = 2; // posisi pusat bubble di bawah tepi atas bar
const double _notchRadius = _bubbleRadius + 8; // jari-jari cekungan
const double _fillet = 10; // kehalusan bahu cekungan
const double _corner = 20; // radius sudut bar
const double _inset = 8; // jarak item ke tepi bar

/// Jarak horizontal dari pusat cekungan ke awal bahu cekungan.
final double _shoulder = math.sqrt(
  (_notchRadius + _fillet) * (_notchRadius + _fillet) -
      (_fillet - _bubbleDy) * (_fillet - _bubbleDy),
);

class _NavItemData {
  const _NavItemData(this.icon, this.selectedIcon, this.label);

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

const _items = [
  _NavItemData(Icons.home_outlined, Icons.home_rounded, 'Beranda'),
  _NavItemData(Icons.explore_outlined, Icons.explore_rounded, 'Jelajahi'),
  _NavItemData(Icons.bookmarks_outlined, Icons.bookmarks_rounded, 'Tersimpan'),
];

/// Navigation bar dengan bubble yang naik dan cekungan yang bergeser
/// mengikuti tab aktif.
class AppNavigationBar extends ConsumerWidget {
  const AppNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final barColor = isDark
        ? scheme.surfaceContainerHigh
        : scheme.surfaceContainerLowest;
    final bookmarkCount =
        ref.watch(bookmarksProvider).asData?.value.length ?? 0;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final itemWidth = (width - _inset * 2) / _items.length;
            final minCenter = _corner + _shoulder;

            double centerOf(double pos) =>
                (_inset + (pos + 0.5) * itemWidth)
                    .clamp(minCenter, width - minCenter)
                    .toDouble();

            return SizedBox(
              height: _overhang + _barHeight,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(end: currentIndex.toDouble()),
                duration: const Duration(milliseconds: 380),
                curve: Curves.easeInOutCubic,
                builder: (context, pos, _) {
                  final cx = centerOf(pos);
                  final shownIndex = pos.round().clamp(0, _items.length - 1);

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Bar putih dengan cekungan.
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _BarPainter(
                            cx: cx,
                            color: barColor,
                            borderColor: scheme.outlineVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ),
                      // Item (ikon + label).
                      Positioned(
                        left: _inset,
                        right: _inset,
                        top: _overhang,
                        height: _barHeight,
                        child: Row(
                          children: [
                            for (var i = 0; i < _items.length; i++)
                              Expanded(
                                child: _NavItem(
                                  data: _items[i],
                                  activeness: (1 - (pos - i).abs()).clamp(
                                    0.0,
                                    1.0,
                                  ),
                                  selected: i == currentIndex,
                                  badgeCount: i == 2 ? bookmarkCount : 0,
                                  onTap: () {
                                    if (i != currentIndex) {
                                      HapticFeedback.selectionClick();
                                    }
                                    onTap(i);
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Bubble yang bergeser.
                      Positioned(
                        left: cx - _bubbleRadius,
                        top: _overhang + _bubbleDy - _bubbleRadius,
                        child: IgnorePointer(
                          child: Material(
                            color: barColor,
                            elevation: 4,
                            shadowColor: Colors.black.withValues(alpha: 0.35),
                            shape: CircleBorder(
                              side: BorderSide(
                                color: scheme.primary.withValues(alpha: 0.18),
                              ),
                            ),
                            child: SizedBox(
                              width: _bubbleRadius * 2,
                              height: _bubbleRadius * 2,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 220),
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    ),
                                child: Icon(
                                  _items[shownIndex].selectedIcon,
                                  key: ValueKey(shownIndex),
                                  color: scheme.primary,
                                  size: 26,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Satu item: ikon (memudar saat bubble datang) + label.
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.data,
    required this.activeness,
    required this.selected,
    required this.badgeCount,
    required this.onTap,
  });

  final _NavItemData data;

  /// 0 = tidak aktif, 1 = bubble tepat di atas item ini.
  final double activeness;
  final bool selected;
  final int badgeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    Widget icon = Icon(
      data.icon,
      size: 24,
      color: scheme.onSurfaceVariant,
    );
    if (badgeCount > 0) {
      icon = Badge.count(count: badgeCount, child: icon);
    }

    return Semantics(
      button: true,
      selected: selected,
      label: data.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          children: [
            const SizedBox(height: 14),
            Opacity(opacity: 1 - activeness, child: icon),
            const Spacer(),
            Text(
              data.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                color: Color.lerp(
                  scheme.onSurfaceVariant,
                  scheme.onSurface,
                  activeness,
                ),
                fontWeight: activeness > 0.5
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

/// Menggambar bar bersudut membulat dengan cekungan setengah lingkaran
/// di posisi [cx] (tepi cekungan dihaluskan).
class _BarPainter extends CustomPainter {
  _BarPainter({
    required this.cx,
    required this.color,
    required this.borderColor,
  });

  final double cx;
  final Color color;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    const t = _overhang;
    const h = _barHeight;
    const r = _notchRadius;
    const f = _fillet;
    const rc = _corner;
    const cy = t + _bubbleDy;

    final dx = _shoulder;
    final k = r / (r + f);
    final tangentY = cy + (f - _bubbleDy) * k;

    final path = Path()
      ..moveTo(0, t + rc)
      ..arcToPoint(const Offset(rc, t), radius: const Radius.circular(rc))
      ..lineTo(cx - dx, t)
      ..arcToPoint(
        Offset(cx - dx * k, tangentY),
        radius: const Radius.circular(f),
      )
      ..arcToPoint(
        Offset(cx + dx * k, tangentY),
        radius: const Radius.circular(r),
        clockwise: false,
      )
      ..arcToPoint(Offset(cx + dx, t), radius: const Radius.circular(f))
      ..lineTo(w - rc, t)
      ..arcToPoint(Offset(w, t + rc), radius: const Radius.circular(rc))
      ..lineTo(w, t + h - rc)
      ..arcToPoint(Offset(w - rc, t + h), radius: const Radius.circular(rc))
      ..lineTo(rc, t + h)
      ..arcToPoint(Offset(0, t + h - rc), radius: const Radius.circular(rc))
      ..close();

    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.5), 6, false);
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = borderColor,
    );
  }

  @override
  bool shouldRepaint(_BarPainter old) =>
      old.cx != cx || old.color != color || old.borderColor != borderColor;
}