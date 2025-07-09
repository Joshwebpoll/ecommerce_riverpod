// import 'dart:convert';

// import 'package:riverpod_ecommerce/models/product_model.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class CartService {
//   final storage = FlutterSecureStorage();

//   Future<void> addToCart(Product product) async {
//     print(product);
//     final List<Product> cartItems = await getCart();
//     cartItems.add(product);

//     final encoded = jsonEncode(cartItems.map((p) => p.toJson()).toList());
//     print(encoded);
//     await storage.write(key: 'cart', value: encoded);
//   }

//   Future<List<Product>> getCart() async {
//     final String? product = await storage.read(key: 'cart');
//     if (product == null) {
//       print('empty');
//       return [];
//     }
//     final List<dynamic> decondedProduct = jsonDecode(product);
//     return decondedProduct.map((data) => Product.fromJson(data)).toList();
//   }
// }

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_ecommerce/models/cart_model.dart';
import 'package:riverpod_ecommerce/models/product_model.dart';

class CartService {
  final storage = FlutterSecureStorage();

  Future<void> addToCart(Product product) async {
    try {
      final List<CartItem> cartItems = await getCart();
      print('kskk ${product}');
      // Check if product already exists
      final index = cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (index != -1) {
        cartItems[index].quantity += 1;
      } else {
        cartItems.add(CartItem(product: product));
      }

      // final encoded = jsonEncode(
      //   cartItems.map((item) => item.toJson()).toList(),
      // );

      final encoded = jsonEncode(
        cartItems.map((item) => item.toJson()).toList(),
      );
      await storage.write(key: 'cart', value: encoded);
      print('Cart Saved: $encoded');
    } catch (e) {
      print(e);
    }
  }

  Future<List<CartItem>> getCart() async {
    final String? product = await storage.read(key: 'cart');
    if (product == null) {
      print('empty');
      return [];
    }
    final List<dynamic> decodedProduct = jsonDecode(product);
    return decodedProduct.map((data) => CartItem.fromJson(data)).toList();
  }

  Future<void> removeFromCart(int productId) async {
    final List<CartItem> cartItems = await getCart();
    cartItems.removeWhere((item) => item.product.id == productId);

    final encoded = jsonEncode(cartItems.map((item) => item.toJson()).toList());
    await storage.write(key: 'cart', value: encoded);
  }

  Future<void> clearCart() async {
    await storage.delete(key: 'cart');
  }

  Future<double> calculateTotal() async {
    final List<CartItem> cartItems = await getCart();

    final total = cartItems.fold(0.0, (sum, item) {
      return sum + (item.product.price * item.quantity);
    });

    return total;
  }

  Future<void> saveCart(List<CartItem> cartItems) async {
    final encoded = jsonEncode(cartItems.map((item) => item.toJson()).toList());
    await storage.write(key: 'cart', value: encoded);
  }
}
