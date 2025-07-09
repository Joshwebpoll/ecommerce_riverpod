import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecommerce/models/category_model.dart';
import 'package:riverpod_ecommerce/provider/product_provider.dart';

class ProductCategory extends ConsumerStatefulWidget {
  final Category cat;
  const ProductCategory({super.key, required this.cat});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductCategoryState();
}

class _ProductCategoryState extends ConsumerState<ProductCategory> {
  @override
  Widget build(BuildContext context) {
    final productNotifier = ref.watch(productProvider);
    final productCat = ref.watch(
      filterProductByCategoryProvider(widget.cat.name),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, size: 20),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(widget.cat.name, style: TextStyle(fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            productNotifier.when(
              data:
                  (_) =>
                      productCat.isEmpty
                          ? Center(child: Text('No Product Available'))
                          : Expanded(
                            child: ListView.separated(
                              itemCount: productCat.length,
                              itemBuilder: (context, index) {
                                final prod = productCat[index];
                                return Row(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/product_details',
                                          arguments: prod,
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          prod.images[0],
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.contain,
                                          loadingBuilder: (
                                            context,
                                            child,
                                            loadingProgress,
                                          ) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return SizedBox(
                                              height: 20,
                                              width: 20,
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(
                                                    Icons.broken_image,
                                                    size: 50,
                                                  ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            prod.title,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text('\$${prod.price.toString()}'),
                                      ],
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder:
                                  (context, index) => SizedBox(height: 16),
                            ),
                          ),
              error: (e, _) => Text('$e'),
              loading: () => CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
