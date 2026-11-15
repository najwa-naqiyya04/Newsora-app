import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/url_helper.dart';

/// Baris atas: tombol kembali + menu titik tiga.
class DetailTopBar extends StatelessWidget {
  const DetailTopBar({super.key, required this.url});

  final String url;

  Future<void> _copyLink(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: url));
    messenger.showSnackBar(
      const SnackBar(content: Text('Tautan artikel disalin')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Kembali',
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const Spacer(),
          PopupMenuButton<String>(
            tooltip: 'Opsi',
            icon: const Icon(Icons.more_horiz_rounded),
            onSelected: (value) {
              if (value == 'copy') {
                _copyLink(context);
              } else if (value == 'open') {
                UrlHelper.open(context, url);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'copy',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.link_rounded),
                  title: Text('Salin tautan'),
                ),
              ),
              PopupMenuItem(
                value: 'open',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.open_in_new_rounded),
                  title: Text('Buka di browser'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}