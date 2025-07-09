import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecommerce/models/cart_model.dart';
import 'package:riverpod_ecommerce/models/product_model.dart';
import 'package:riverpod_ecommerce/services/cart_service.dart';

final cartProvider = Provider<CartService>((ref) {
  return CartService();
});

final cartStateProvider =
    StateNotifierProvider<CartNotifier, AsyncValue<List<CartItem>>>((ref) {
      return CartNotifier(ref);
    });

class CartNotifier extends StateNotifier<AsyncValue<List<CartItem>>> {
  final Ref ref;
  CartNotifier(this.ref) : super(const AsyncLoading()) {
    getAllCart();
  }

  Future<bool> addCart(Product product) async {
    if (state is AsyncData<List<CartItem>>) {
      final cartItems = (state as AsyncData<List<CartItem>>).value;
      final index = cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (index != -1) {
        cartItems[index].quantity += 1;
        return false;
      } else {
        cartItems.add(CartItem(product: product));
      }

      state = AsyncValue.data(List.from(cartItems));

      await ref.read(cartProvider).saveCart(cartItems);
      return true;
    }
    return false;
  }

  // Future<void> addCart(Product product) async {
  //   try {
  //     await ref.read(cartProvider).addToCart(product);
  //     await getAllCart();
  //   } catch (e) {
  //     state = AsyncError(e, StackTrace.current);
  //   }
  // }

  Future<void> getAllCart() async {
    state = const AsyncLoading();
    try {
      final cart = await ref.read(cartProvider).getCart();
      state = AsyncData(cart);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  // Future<void> removeCarts(productId) async {
  //   try {
  //     await ref.read(cartProvider).removeFromCart(productId);
  //     await getAllCart();
  //   } catch (e) {
  //     state = AsyncError(e, StackTrace.current);
  //   }
  // }

  Future<bool> removeFromCart(int productId) async {
    if (state is AsyncData<List<CartItem>>) {
      final cartItems = (state as AsyncData<List<CartItem>>).value;
      cartItems.removeWhere((item) => item.product.id == productId);
      state = AsyncValue.data(List.from(cartItems));
      await ref.read(cartProvider).saveCart(cartItems);
      return true;
    }
    return false;
  }

  double getTotal() {
    if (state is AsyncData<List<CartItem>>) {
      final cartItems = (state as AsyncData<List<CartItem>>).value;
      return cartItems.fold(
        0.0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );
    }
    return 0.0;
  }

  Future<void> deletCarts() async {
    try {
      await ref.read(cartProvider).clearCart();
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<bool> increaseCart(productId) async {
    if (state is AsyncData<List<CartItem>>) {
      final cartItems = (state as AsyncData<List<CartItem>>).value;
      final updatedQuantity =
          cartItems.map((item) {
            if (item.product.id == productId) {
              return CartItem(
                product: item.product,
                quantity: item.quantity + 1,
              );
            }
            return item;
          }).toList();
      state = AsyncData(updatedQuantity);
      await ref.read(cartProvider).saveCart(updatedQuantity);
      return true;
    }
    return false;
  }

  Future<bool> decreaseCart(productId) async {
    if (state is AsyncData<List<CartItem>>) {
      final cartItems = (state as AsyncData<List<CartItem>>).value;
      final updatedCart =
          cartItems.where((item) {
            if (item.product.id == productId) {
              if (item.quantity > 1) {
                item.quantity -= 1;
                return true;
              }
              return false; // Remove item if quantity reaches 0
            }
            return true;
          }).toList();
      state = AsyncValue.data(updatedCart);
      await ref.read(cartProvider).saveCart(updatedCart);
      return true;
    }
    return false;
  }
}

final cartTotalProvider = Provider<double>((ref) {
  final cartState = ref.watch(cartStateProvider);

  return cartState.maybeWhen(
    data: (cartItems) {
      return cartItems.fold(0.0, (sum, item) {
        return sum + (item.product.price * item.quantity);
      });
    },
    orElse: () => 0.0,
  );
});
