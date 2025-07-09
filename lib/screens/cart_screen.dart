import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_ecommerce/provider/cart_provider.dart';
import 'package:riverpod_ecommerce/utils/app_toast.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = ref.watch(cartStateProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, size: 20),
        ),
        title: Text(
          'Cart',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: cartProvider.when(
            data: (carts) {
              if (carts.isEmpty) {
                return Center(
                  child: Text(
                    'Cart is Empty',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap:
                    true, // Important to prevent unbounded height errors inside SingleChildScrollView
                physics: NeverScrollableScrollPhysics(),
                itemCount: carts.length,
                itemBuilder: (context, index) {
                  final cart = carts[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xfff5f5f5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              cart.product.images[0],
                              width: 50,
                              height: 50,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      Icon(Icons.broken_image, size: 20),
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) {
                                  return child;
                                }

                                return Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 130,
                                child: Text(
                                  cart.product.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                cart.product.category.name,

                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '\$${cart.product.price}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  final remove = await ref
                                      .read(cartStateProvider.notifier)
                                      .removeFromCart(cart.product.id);

                                  if (remove) {
                                    if (!context.mounted) return;
                                    AppToast.show(
                                      context,
                                      "Remove from cart",

                                      type: ToastTypes.success,
                                      position: ToastPosition.bottom,
                                      duration: Duration(seconds: 5),
                                    );
                                  } else {
                                    if (!context.mounted) return;
                                    AppToast.show(
                                      context,
                                      "Something went wrong",

                                      type: ToastTypes.success,
                                      position: ToastPosition.bottom,
                                      duration: Duration(seconds: 5),
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.delete,
                                  size: 20,
                                  color: Color(0xffeeaa7c),
                                ),
                              ),
                              Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Color(0xffdedbdc),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        final decrease = await ref
                                            .read(cartStateProvider.notifier)
                                            .decreaseCart(cart.product.id);
                                        if (decrease) {
                                          if (!context.mounted) return;
                                          AppToast.show(
                                            context,
                                            "Cart quantity decrease",

                                            type: ToastTypes.success,
                                            position: ToastPosition.bottom,
                                            duration: Duration(seconds: 5),
                                          );
                                        } else {
                                          if (!context.mounted) return;
                                          AppToast.show(
                                            context,
                                            "Something went wrong",

                                            type: ToastTypes.success,
                                            position: ToastPosition.bottom,
                                            duration: Duration(seconds: 5),
                                          );
                                        }
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        color: Colors.black,
                                        size: 15,
                                      ),
                                    ),
                                    Text(
                                      cart.quantity.toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        final increase = await ref
                                            .read(cartStateProvider.notifier)
                                            .increaseCart(cart.product.id);

                                        if (increase) {
                                          if (!context.mounted) return;
                                          AppToast.show(
                                            context,
                                            "Cart quantity increase",

                                            type: ToastTypes.success,
                                            position: ToastPosition.bottom,
                                            duration: Duration(seconds: 5),
                                          );
                                        } else {
                                          if (!context.mounted) return;
                                          AppToast.show(
                                            context,
                                            "Something went wrong",

                                            type: ToastTypes.success,
                                            position: ToastPosition.bottom,
                                            duration: Duration(seconds: 5),
                                          );
                                        }
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.black,
                                        size: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            error:
                (e, _) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.warning, size: 30),
                    Text(
                      'Failed to fetch product',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
            loading:
                () => Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
                ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              //'Total: \$${ref.watch(cartStateProvider.notifier).getTotal().toStringAsFixed(2)}',
              // 'Total: \$${ref.watch(cartTotalProvider).toStringAsFixed(2)}',
              'Total: ${NumberFormat.currency(symbol: '\$').format(ref.watch(cartTotalProvider))}',
              style: TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () {
                // AppToast.show(
                //   context,
                //   'Added to cart',
                //   type: ToastTypes.success,
                //   position: ToastPosition.bottom,
                //   duration: Duration(seconds: 5),
                // );
              },
              child: Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
