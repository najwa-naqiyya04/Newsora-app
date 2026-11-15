import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/navigation_provider.dart';
import 'package:news_app/providers/search_provider.dart';
import 'package:news_app/providers/theme_provider.dart';

import '../../../../core/utils/date_formatter.dart';

/// Warna "News" di atas latar biru (merah terang supaya terbaca).
const Color _newsColor = Color(0xFFFF4D5E);

/// Header home: kotak biru membulat di bawah berisi tanggal, nama Newsora,
/// tombol mode gelap/terang, dan kolom pencarian.
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final topInset = MediaQuery.paddingOf(context).top;

    final gradient = isDark
        ? const [Color(0xFF0B2559), Color(0xFF133C85)]
        : const [Color(0xFF003380), Color(0xFF0B52C4)];

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          // Ikon status bar jadi putih di atas latar biru.
          value: SystemUiOverlayStyle.light,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient,
                ),
              ),
              child: Stack(
                children: [
                  // Hiasan lingkaran tipis di latar.
                  const Positioned(
                    right: -50,
                    top: -60,
                    child: _Ring(size: 200),
                  ),
                  const Positioned(
                    right: 10,
                    top: -20,
                    child: _Ring(size: 120),
                  ),
                  const Positioned(
                    left: -40,
                    bottom: -70,
                    child: _Ring(size: 160),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, topInset + 12, 20, 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormatter.today(),
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text.rich(
                                    const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'News',
                                          style: TextStyle(color: _newsColor),
                                        ),
                                        TextSpan(
                                          text: 'ora',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.5,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const _ThemeToggle(),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const _HomeSearchField(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Lingkaran garis tipis sebagai hiasan latar.
class _Ring extends StatelessWidget {
  const _Ring({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1.5,
        ),
      ),
    );
  }
}

/// Tombol kotak membulat transparan untuk ganti mode gelap/terang.
class _ThemeToggle extends ConsumerWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Tooltip(
      message: isDark ? 'Mode terang' : 'Mode gelap',
      child: Material(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => ref.read(themeModeProvider.notifier).toggle(brightness),
          child: SizedBox(
            width: 46,
            height: 46,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => RotationTransition(
                turns: Tween(begin: 0.75, end: 1.0).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_outlined,
                key: ValueKey(isDark),
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Kolom pencarian. Saat Enter ditekan, kata kunci dikirim lalu
/// otomatis pindah ke tab Jelajahi untuk menampilkan hasilnya.
class _HomeSearchField extends ConsumerStatefulWidget {
  const _HomeSearchField();

  @override
  ConsumerState<_HomeSearchField> createState() => _HomeSearchFieldState();
}

class _HomeSearchFieldState extends ConsumerState<_HomeSearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(String value) {
    final query = value.trim();
    if (query.isEmpty) return;

    FocusScope.of(context).unfocus();
    ref.read(SearchQueryProvider.notifier).submit(query);
    ref.read(NavigationProvider.notifier).select(1);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      onSubmitted: _submit,
      decoration: InputDecoration(
        hintText: 'Cari berita, topik, atau tokoh',
        filled: true,
        fillColor: scheme.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        prefixIcon: Icon(Icons.search_rounded, color: scheme.primary),
        suffixIcon: ListenableBuilder(
          listenable: _controller,
          builder: (_, _) => _controller.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  tooltip: 'Hapus',
                  icon: const Icon(Icons.close_rounded),
                  onPressed: _controller.clear,
                ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}