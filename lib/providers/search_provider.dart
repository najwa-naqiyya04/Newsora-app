// import '../data/models/article.dart';


// TODO 9: Implementasi SearchProvider
// 1. Buat class SearchNotifier extends AsyncNotifier<List<Article>>
// 2. Di dalam build(), return [] sebagai nilai awal
// 3. Buat fungsi search(String query) untuk memanggil NewsRepository.searchArticles() dan menyimpan hasilnya di state
// 4. Buat searchProvider (AsyncNotifierProvider) untuk digunakan di UI


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/data/models/article.dart';
import 'package:news_app/providers/dependency_provider.dart';
import 'package:news_app/ui/screens/search/widgets/search_results.dart';


class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';


  // dicari berdasarkan query dan akan dijalankan ketika user menekan tombol enter
  void submit(String query) => state = query.trim();
  void clear() => state = ''; //serach provider akan membersihkan state
}


final SearchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
); // provider akan memberitahukan class terkait (search result)


// hasil pencarian: otomatis fetch ulang setiap kali query berubah
// dia kana dijalankan ketika pencarian itu succes
final searchResultProvider = FutureProvider.autoDispose<List<Article>>((
  ref, // akan dijadikan parameter karena dia didalam anonimus function
) async {
  final query = ref.watch(SearchQueryProvider);
  if (query.isEmpty) return [];
  return ref.watch(newsRepositoryProvider).searchArticles(query);
});


// alias agar dapat diakses dengan nama searchResultProvider maupun searchResultsProvider
final SearchResultsProvider = searchResultProvider;