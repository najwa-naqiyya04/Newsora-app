import 'package:flutter/material.dart';

/// Membungkus satu kartu agar punya efek "tumpukan -> berbaris" saat di-scroll.
///
/// Saat kartu baru masuk dari tepi bawah layar, kartu tampil sedikit mengecil,
/// agak naik (menumpuk di atas kartu sebelumnya) dan samar. Semakin kartu
/// bergeser ke atas oleh jempol, kartu melebar, turun, lalu berbaris rapi.
/// Efek berlaku dua arah (scroll naik maupun turun).
class ScrollStackItem extends StatefulWidget {
  const ScrollStackItem({super.key, required this.child});

  final Widget child;

  @override
  State<ScrollStackItem> createState() => _ScrollStackItemState();
}

class _ScrollStackItemState extends State<ScrollStackItem> {
  ScrollPosition? _position;

  @override
  void initState() {
    super.initState();
    // Hitung ulang sekali setelah layout pertama supaya posisi awal akurat.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _position = Scrollable.maybeOf(context)?.position;
  }

  /// 0 = kartu baru muncul di tepi bawah, 1 = sudah berada di posisi normal.
  double _progress() {
    final box = context.findRenderObject();
    final viewport = Scrollable.maybeOf(context)?.context.findRenderObject();
    if (box is! RenderBox ||
        viewport is! RenderBox ||
        !box.attached ||
        !box.hasSize ||
        !viewport.hasSize) {
      return 1;
    }
    final top = box.localToGlobal(Offset.zero, ancestor: viewport).dy;
    final viewportHeight = viewport.size.height;
    final zone = viewportHeight * 0.32;
    return ((viewportHeight - top) / zone).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final position = _position;
    if (position == null || MediaQuery.disableAnimationsOf(context)) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: position,
      child: widget.child,
      builder: (context, child) {
        final t = Curves.easeOutCubic.transform(_progress());
        return Opacity(
          opacity: 0.25 + 0.75 * t,
          child: Transform.translate(
            offset: Offset(0, -(1 - t) * 36),
            child: Transform.scale(
              scale: 0.92 + 0.08 * t,
              alignment: Alignment.topCenter,
              child: child,
            ),
          ),
        );
      },
    );
  }
}