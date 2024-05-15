import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:search_app/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ProductNotifierProvider =
    StateNotifierProvider<ProductNotifier, List<String>>(
        (ref) => ProductNotifier(ref.watch(userSettingsProvider)));

class ProductNotifier extends StateNotifier<List<String>> {
  UserSetting settings;

  ProductNotifier(this.settings) : super([]) {
    _updateProductList();
  }

  void _updateProductList() {
    List<String> productList = settings.langage == 'English'
        ? ['Appple', 'Banana', 'Cherry', 'Orange', 'Peach', 'Grape']
        : ['りんご', 'ばなな', 'さくらんぼ', 'みかん', 'もも', 'ぶどう'];
    state = productList;
  }

  void search(String query) {
    _updateProductList();

    if (query.isNotEmpty) {
      state = state
          .where(
              (product) => product.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
