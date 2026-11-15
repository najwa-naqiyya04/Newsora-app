// TODO 6: Implementasi ThemeProvider
// 1. Install Riverpod: `flutter pub add flutter_riverpod`
// 2. Import 'package:flutter_riverpod/flutter_riverpod.dart';
// 3. Buat class ThemeNotifier extends Notifier<bool> (menyimpan state isDarkMode)
// 4. Implementasikan fungsi toggleTheme() untuk mengubah state dan menyimpannya di SharedPreferences
// 5. Buat themeProvider (NotifierProvider) untuk digunakan di UI

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/data/services/theme_storage.dart';

final themeStorageProvider = Provider<ThemeStorage>((ref) => ThemeStorage());

//tema awal yg di baca di 'main.dart' sebeleum app tampil berjalan secara asinkron
//nilainya di-override lewat 'providerScopr.override'

final initialThemeModeProvider = Provider<ThemeMode>((ref) => ThemeMode.system);

//mode tema yg aktif bisa terang atau gelap dan dia akan defult mengikuti sistem
class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ref.read(initialThemeModeProvider);

  //berahli ke kembali dari tema yg sedang tampil atau aktif
  void toggle(Brightness currentBrightnes) {
    state = currentBrightnes == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    ref.read(themeStorageProvider).save(state);
  }
}


//TODO; deklarasikan sebuah notifier untuk memberitahukan perubahan yang terjadi
//agar aplikasi dapat mengetahui bahwa ada perubahan yanng akan terjadi pada theme
final themeModeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new
);
