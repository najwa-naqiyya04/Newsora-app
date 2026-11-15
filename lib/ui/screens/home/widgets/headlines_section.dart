import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/headlines_provider.dart';
import 'package:news_app/ui/widgets/empty_state.dart';
import 'package:news_app/ui/widgets/error_state.dart';

import 'home_skeletons.dart';
import 'news_tile.dart';
import 'scroll_stack_item.dart';

/// Daftar kartu kecil berita (mulai dari berita ke-2).
class HeadlinesSection extends ConsumerWidget {
  const HeadlinesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(selectedCategoryProvider);
    final headlines = ref.watch(headlinesProvider(category));

    return headlines.when(
      loading: () => const SliverToBoxAdapter(child: TileListSkeleton()),
      error: (error, _) => SliverFillRemaining(
        hasScrollBody: false,
        child: ErrorState(
          error: error,
          onRetry: () => ref.invalidate(headlinesProvider),
        ),
      ),
      data: (articles) {
        if (articles.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyState(
              icon: Icons.newspaper_rounded,
              title: 'belum ada berita',
              message: 'Coba Pilih Kategori lain, atau tarik untuk refresh',
            ),
          );
        }

        final rest = articles.skip(1).toList();
        if (rest.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          sliver: SliverList.builder(
            itemCount: rest.length,
            itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ScrollStackItem(
                key: ValueKey(rest[index].url),
                child: NewsTile(article: rest[index]),
              ),
            ),
          ),
        );
      },
    );
  }
}