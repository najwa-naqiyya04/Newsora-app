import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/headlines_provider.dart';

import 'featured_news_card.dart';
import 'home_skeletons.dart';

/// Menampilkan berita pertama dari kategori terpilih sebagai kartu besar.
class FeaturedSection extends ConsumerWidget {
  const FeaturedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(selectedCategoryProvider);
    final headlines = ref.watch(headlinesProvider(category));

    return SliverToBoxAdapter(
      child: headlines.when(
        loading: () => const FeaturedSkeleton(),
        // Error & kosong ditampilkan oleh HeadlinesSection di bawah.
        error: (_, _) => const SizedBox.shrink(),
        data: (articles) => articles.isEmpty
            ? const SizedBox.shrink()
            : FeaturedNewsCard(article: articles.first, tag: category.label),
      ),
    );
  }
}