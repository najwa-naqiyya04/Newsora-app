// penyimpanan lokal articel yg ada di bookmark (sharedprefenrences)

import 'dart:convert';

import 'package:news_app/data/models/article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkStorage {
  static const String _key = 'bookmark_articles';

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  Future<List<Article>> load() async {
    final raw = await _prefs.getStringList(_key) ?? [];
    return raw
        .map(
          (item) => Article.fromJson(jsonDecode(item) as Map<String, dynamic>),
        )
      // ubah format string menjadi json dan untuk mencocokan tipe data yg sebelum nya map menjadi list
      .toList();
  }

  //function yg di ja;ankan ketika user mem-bookmark sebuah articel
  Future<void> save(List<Article> articles) {
    final raw = articles 
        .map((article) => jsonEncode(article.toJson()))
        .toList();
    return _prefs.setStringList(_key, raw);
  }
}

