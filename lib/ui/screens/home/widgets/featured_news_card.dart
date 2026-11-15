import 'package:flutter/material.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../data/models/article.dart';
import '../../../widgets/article_image.dart';
import '../../../widgets/red_bookmark_button.dart';

/// Kartu besar untuk 1 berita unggulan: gambar penuh, label kategori,
/// judul putih, sumber, dan waktu terbit.
class FeaturedNewsCard extends StatelessWidget {
  const FeaturedNewsCard({super.key, required this.article, required this.tag});

  final Article article;

  /// Teks label kecil di atas judul (nama kategori).
  final String tag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final source = article.sourceName.trim();
    final initial = source.isEmpty ? '?' : source[0].toUpperCase();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: AspectRatio(
        aspectRatio: 0.92,
        child: Material(
          color: theme.colorScheme.surfaceContainerHighest,
          elevation: 3,
          shadowColor: Colors.black.withValues(alpha: 0.25),
          surfaceTintColor: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: InkWell(
            onTap: () => AppRouter.openArticle(context, article),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ArticleImage(url: article.imageUrl, radius: 0),
                // Lapisan gelap supaya teks putih terbaca.
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.4, 1.0],
                      colors: [
                        Color(0x40000000),
                        Color(0x00000000),
                        Color(0xE6000000),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: RedBookmarkButton(article: article, boxed: true),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          tag,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        article.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: RedBookmarkButton.red,
                            child: Text(
                              initial,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              source.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormatter.relative(article.publishedAt),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
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