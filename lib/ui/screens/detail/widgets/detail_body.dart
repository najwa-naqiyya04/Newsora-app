import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../data/models/article.dart';
import '../../../widgets/article_image.dart';
import '../../../widgets/red_bookmark_button.dart';

/// Judul, baris penulis, dan kartu putih berisi gambar + isi artikel.
class DetailBody extends StatelessWidget {
  const DetailBody({super.key, required this.article});

  final Article article;

  Future<void> _copyLink(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: article.url));
    messenger.showSnackBar(
      const SnackBar(content: Text('Tautan artikel disalin')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final description = article.description ?? '';
    final content = article.cleanContent;
    final author = article.author;
    final hasAuthor = author != null && author.trim().isNotEmpty;
    final byline = hasAuthor ? author.trim() : article.sourceName;
    final time = DateFormatter.relative(article.publishedAt);
    final subtitle = hasAuthor ? '$time • ${article.sourceName}' : time;
    final hasImage = article.imageUrl != null && article.imageUrl!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            article.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Baris penulis.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: scheme.primaryContainer,
                foregroundColor: scheme.onPrimaryContainer,
                child: Text(
                  byline.characters.first.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      byline,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Salin tautan',
                icon: const Icon(Icons.send_outlined),
                onPressed: () => _copyLink(context),
              ),
              RedBookmarkButton(article: article, size: 26),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Kartu putih berisi gambar + teks.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Material(
            color: isDark
                ? scheme.surfaceContainerHigh
                : scheme.surfaceContainerLowest,
            elevation: 2,
            shadowColor: Colors.black.withValues(alpha: 0.12),
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasImage)
                    AspectRatio(
                      aspectRatio: 1.5,
                      child: ArticleImage(url: article.imageUrl, radius: 22),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (description.isNotEmpty)
                          Text(
                            description,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                            ),
                          ),
                        if (content.isNotEmpty && content != description) ...[
                          const SizedBox(height: 16),
                          Text(
                            content,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: scheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Ini adalah cuplikan. Baca artikel lengkap '
                                  'di situs ${article.sourceName}.',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}