import 'package:flutter/material.dart';

import '../../../../core/utils/url_helper.dart';

/// Tombol pil melayang "Baca selengkapnya" di kanan bawah.
class ReadMoreFab extends StatelessWidget {
  const ReadMoreFab({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return FloatingActionButton.extended(
      heroTag: null,
      elevation: 6,
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      shape: const StadiumBorder(),
      icon: const Icon(Icons.open_in_new_rounded),
      label: const Text(
        'Baca selengkapnya',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      onPressed: () => UrlHelper.open(context, url),
    );
  }
}