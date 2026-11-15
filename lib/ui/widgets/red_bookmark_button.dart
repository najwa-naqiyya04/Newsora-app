import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/article.dart';
import '../../providers/bookmark_provider.dart';

/// Tombol bookmark berwarna merah.
/// [boxed] = true: kotak putih membulat (untuk di atas gambar).
class RedBookmarkButton extends ConsumerWidget {
  const RedBookmarkButton({
    super.key,
    required this.article,
    this.boxed = false,
    this.size = 22,
  });

  final Article article;
  final bool boxed;
  final double size;

  static const Color red = Color(0xFFE60019);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaved = ref.watch(isBookmarkedProvider(article.url));
    final tooltip = isSaved ? 'Hapus dari Tersimpan' : 'Simpan';
    void toggle() =>
        ref.read(bookmarksProvider.notifier).toggleBookmark(article);

    final icon = Icon(
      isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
      color: red,
      size: size,
    );

    if (boxed) {
      return Tooltip(
        message: tooltip,
        child: Material(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: toggle,
            child: SizedBox(width: 40, height: 40, child: Center(child: icon)),
          ),
        ),
      );
    }

    return IconButton(
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      onPressed: toggle,
      icon: icon,
    );
  }
}