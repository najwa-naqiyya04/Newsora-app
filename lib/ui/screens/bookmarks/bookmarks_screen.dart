import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/data/models/article.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:news_app/ui/widgets/empty_state.dart';
import 'package:news_app/ui/widgets/theme_toggle_button.dart';

import 'widgets/bookmark_item.dart';

/// Halaman Tersimpan: judul di tengah + toggle tema, kolom pencarian,
/// lalu daftar berita yang sudah disimpan.
class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key});

  @override
  ConsumerState<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Cari di judul, sumber, dan deskripsi.
  List<Article> _filter(List<Article> items) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return items;

    return items.where((article) {
      return article.title.toLowerCase().contains(q) ||
          article.sourceName.toLowerCase().contains(q) ||
          (article.description ?? '').toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bookmarksAsync = ref.watch(bookmarksProvider);

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Judul di tengah, toggle mode gelap/terang di kanan.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 4, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Tersimpan',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const ThemeToggleButton(),
              ],
            ),
          ),
          // Kolom pencarian berbentuk kapsul.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Cari berita tersimpan...',
                filled: true,
                fillColor: scheme.surfaceContainerHigh,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Hapus',
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: bookmarksAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Center(child: Text('Gagal memuat bookmark: $error')),
              data: (bookmarks) {
                if (bookmarks.isEmpty) {
                  return const EmptyState(
                    icon: Icons.bookmark_border_rounded,
                    title: 'Belum ada berita tersimpan',
                    message:
                        'Ketuk ikon bookmark pada berita\nuntuk membacanya nanti.',
                  );
                }

                final results = _filter(bookmarks);
                if (results.isEmpty) {
                  return EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'Tidak ditemukan',
                    message:
                        'Tidak ada berita tersimpan yang cocok\ndengan "${_query.trim()}".',
                  );
                }

                return ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: results.length,
                  itemBuilder: (_, index) =>
                      BookmarkItem(article: results[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}