import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecommerce/models/category_model.dart';
import 'package:riverpod_ecommerce/services/category_service.dart';

final categoryServiceProvider = Provider<CategoryService>((ref) {
  return CategoryService();
});

final categoryProvider =
    StateNotifierProvider<CategoryProvider, AsyncValue<List<Category>>>((ref) {
      return CategoryProvider(ref);
    });

class CategoryProvider extends StateNotifier<AsyncValue<List<Category>>> {
  final Ref ref;
  CategoryProvider(this.ref) : super(const AsyncLoading()) {
    getCategory();
  }

  Future<void> getCategory() async {
    state = const AsyncLoading();
    try {
      final categories =
          await ref.read(categoryServiceProvider).fetchCategory();
      state = AsyncData(categories);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
