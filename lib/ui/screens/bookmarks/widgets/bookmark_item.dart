import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/core/router/app_router.dart';
import 'package:news_app/core/utils/date_formatter.dart';
import 'package:news_app/data/models/article.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:news_app/ui/widgets/article_image.dart';

/// Satu baris berita tersimpan: poster di kiri, judul + tanggal + sumber,
/// ikon bookmark merah di kanan. Geser ke kiri atau ketuk ikon untuk menghapus.
class BookmarkItem extends ConsumerWidget {
  const BookmarkItem({super.key, required this.article});

  final Article article;

  static const Color _red = Color(0xFFE60019);

  void _remove(BuildContext context, WidgetRef ref) {
    final messenger = ScaffoldMessenger.of(context);
    final notifier = ref.read(bookmarksProvider.notifier);

    notifier.toggleBookmark(article);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Dihapus dari Tersimpan'),
          action: SnackBarAction(
            label: 'Urungkan',
            onPressed: () => notifier.toggleBookmark(article),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Dismissible(
      key: ValueKey(article.url),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _remove(context, ref),
      background: Container(
        color: scheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Icon(
          Icons.delete_outline_rounded,
          color: scheme.onErrorContainer,
        ),
      ),
      child: Material(
        color: scheme.surface,
        child: InkWell(
          onTap: () => AppRouter.openArticle(context, article),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
            child: Row(
              children: [
                ArticleImage(
                  url: article.imageUrl,
                  width: 78,
                  height: 108,
                  radius: 10,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        DateFormatter.relative(article.publishedAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        article.sourceName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Hapus dari Tersimpan',
                  onPressed: () => _remove(context, ref),
                  icon: const Icon(Icons.bookmark_rounded, color: _red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}