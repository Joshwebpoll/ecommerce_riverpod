import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecommerce/models/product_model.dart';
import 'package:riverpod_ecommerce/services/product_service.dart';

final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});
final productProvider =
    StateNotifierProvider<ProductProvider, AsyncValue<List<Product>>>((ref) {
      return ProductProvider(ref);
    });

class ProductProvider extends StateNotifier<AsyncValue<List<Product>>> {
  final Ref ref;
  ProductProvider(this.ref) : super(const AsyncLoading()) {
    getProducts();
  }

  Future<void> getProducts() async {
    state = const AsyncValue.loading();
    try {
      final productService =
          await ref.read(productServiceProvider).fetchProduct();

      state = AsyncData(productService);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final filterProductByCategoryProvider = Provider.family<List<Product>, String>((
  ref,
  category,
) {
  final productState = ref.watch(productProvider);
  return productState.maybeWhen(
    data:
        (data) =>
            data.where((product) => product.category.name == category).toList(),
    orElse: () => [],
  );
});
