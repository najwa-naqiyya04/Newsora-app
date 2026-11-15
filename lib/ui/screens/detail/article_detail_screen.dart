import 'package:flutter/material.dart';

import '../../../data/models/article.dart';
import 'widgets/detail_body.dart';
import 'widgets/detail_top_bar.dart';
import 'widgets/read_more_fab.dart';

/// Halaman detail artikel: latar gradasi, judul besar, kartu isi,
/// dan tombol "Baca selengkapnya" melayang.
class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      floatingActionButton: ReadMoreFab(url: article.url),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.55],
            colors: [
              scheme.primaryContainer.withValues(alpha: 0.75),
              scheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              DetailTopBar(url: article.url),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 8, bottom: 110),
                  child: DetailBody(article: article),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}