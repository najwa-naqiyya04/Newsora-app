import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

/// Tema Material 3 dengan paduan biru (utama) dan merah (aksen) dari logo Newsora.
class AppTheme {
  AppTheme._();

  static const Color brandBlue = Color(0xFF003380);
  static const Color brandRed = Color(0xFFE60019);

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  /// Biru = primary, merah = secondary (aksen).
  static ColorScheme _scheme(Brightness brightness) {
    final blue = ColorScheme.fromSeed(
      seedColor: brandBlue,
      brightness: brightness,
    );
    final red = ColorScheme.fromSeed(
      seedColor: brandRed,
      brightness: brightness,
    );
    final isLight = brightness == Brightness.light;

    return blue.copyWith(
      primary: isLight ? brandBlue : blue.primary,
      onPrimary: isLight ? Colors.white : blue.onPrimary,
      secondary: isLight ? brandRed : red.primary,
      onSecondary: isLight ? Colors.white : red.onPrimary,
      secondaryContainer: red.primaryContainer,
      onSecondaryContainer: red.onPrimaryContainer,
    );
  }

  static ThemeData _build(Brightness brightness) {
    final scheme = _scheme(brightness);
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    final text = base.textTheme;

    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      textTheme: text.copyWith(
        headlineMedium: text.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineSmall: text.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
        titleLarge: text.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
        titleMedium: text.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        bodyLarge: text.bodyLarge?.copyWith(height: 1.6),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      chipTheme: const ChipThemeData(shape: StadiumBorder()),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.6),
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.secondaryContainer,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}