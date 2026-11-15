import 'package:flutter/material.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../data/models/article.dart';
import '../../../widgets/article_image.dart';
import '../../../widgets/red_bookmark_button.dart';

/// Kartu kecil: thumbnail di kiri, sumber + judul + waktu, bookmark merah di kanan.
class NewsTile extends StatelessWidget {
  const NewsTile({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: isDark ? scheme.surfaceContainerHigh : scheme.surfaceContainerLowest,
      elevation: 1.5,
      shadowColor: Colors.black.withValues(alpha: 0.15),
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: InkWell(
        onTap: () => AppRouter.openArticle(context, article),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ArticleImage(
                url: article.imageUrl,
                width: 88,
                height: 88,
                radius: 16,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.sourceName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      DateFormatter.relative(article.publishedAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              RedBookmarkButton(article: article),
            ],
          ),
        ),
      ),
    );
  }
}