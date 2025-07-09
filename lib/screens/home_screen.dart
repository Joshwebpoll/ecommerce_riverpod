import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecommerce/provider/cart_provider.dart';
import 'package:riverpod_ecommerce/provider/category_provider.dart';
import 'package:riverpod_ecommerce/provider/product_provider.dart';
import 'package:riverpod_ecommerce/provider/user_provider.dart';

import 'package:riverpod_ecommerce/utils/app_toast.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  List<String> banner = [
    'assets/images/ban3.png',
    'assets/images/ban1.png',
    'assets/images/ban2.png',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Forcefully restore status bar in a frame-safe way
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsycn = ref.watch(userProvider);
    final products = ref.watch(productProvider);
    final categories = ref.watch(categoryProvider);
    final cartLength = ref
        .watch(cartStateProvider)
        .maybeWhen(data: (cart) => cart.length, orElse: () => 0);

    return Scaffold(
      backgroundColor: Color(0xFFffffff),

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,

          // surfaceTintColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  userAsycn.when(
                    data:
                        (user) => SizedBox(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        "/profile",
                                        arguments: user,
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: AssetImage(
                                        'assets/images/avatar.png',
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Welcome ${user.firstname}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    error:
                        (e, _) => Text(
                          "Something went wrong",
                          style: TextStyle(fontSize: 15),
                        ),
                    loading:
                        () => Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/cart_screen');
                },
                child: Stack(
                  children: [
                    Icon(Icons.notifications, size: 30),
                    Positioned(
                      right: 0,
                      top: 0,

                      child: Container(
                        width: 20,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amberAccent,
                        ),

                        child: Text(
                          '$cartLength',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // title: Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   mainAxisSize: MainAxisSize.max,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Row(
          //       children: [
          //         CircleAvatar(
          //           backgroundImage: AssetImage("assets/images/avatar.png"),
          //         ),
          //         SizedBox(width: 5),
          //         Text(
          //           'Hello Joshua',
          //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          //         ),
          //       ],
          //     ),
          //     Stack(
          //       children: [
          //         Icon(Icons.notifications, size: 30),
          //         Positioned(
          //           right: 0,
          //           top: 0,

          //           child: Container(
          //             width: 20,
          //             height: 18,
          //             decoration: BoxDecoration(
          //               shape: BoxShape.circle,
          //               color: Colors.amberAccent,
          //             ),

          //             child: Text(
          //               '20',
          //               style: TextStyle(fontSize: 15),
          //               textAlign: TextAlign.center,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                        ),
                      ),
                      SizedBox(height: 10),
                      // ProductImageSwiper(imageUrls: banner),
                      Column(
                        children: [
                          CarouselSlider(
                            items:
                                banner
                                    .map(
                                      (url) => ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          url,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    )
                                    .toList(),
                            options: CarouselOptions(
                              height: 160,

                              autoPlay: true,
                              enlargeCenterPage: true,
                              viewportFraction: 1,
                              onPageChanged:
                                  (index, reason) => {
                                    setState(() {
                                      _currentIndex = index;
                                    }),
                                  },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                banner.asMap().entries.map((entry) {
                                  return Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          _currentIndex == entry.key
                                              ? Color(0xFFff660b)
                                              : Colors.grey[400],
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Shop by Category',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(onPressed: () {}, child: Text('Sell all')),
                        ],
                      ),
                      categories.when(
                        data: (category) {
                          if (category.isEmpty) {
                            return Text('No category');
                          }
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: ListView.builder(
                              itemCount: category.length,
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                final cat = category[index];
                                return Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/product_categories',
                                            arguments: cat,
                                          );
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,

                                          radius:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.04,
                                          child: ClipOval(
                                            child: Image.network(
                                              cat.image,

                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Icon(
                                                    Icons.broken_image,
                                                    size: 20,
                                                  ),
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
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 1,
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        cat.name,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                );
                              },
                            ),
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
                      Column(
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'New In',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text('Sell all'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      products.when(
                        data: (product) {
                          if (product.isEmpty) {
                            return const Center(
                              child: Text('No Products available.'),
                            );
                          }
                          return GridView.builder(
                            itemCount: product.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // 2 columns
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio:
                                      0.7, // Adjust for product card height/width ratio
                                ),
                            itemBuilder: (context, index) {
                              final prod = product[index];

                              return Column(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/product_details',
                                          arguments: prod,
                                        );
                                      },
                                      child: Container(
                                        height: 250,
                                        width: double.infinity,
                                        padding: EdgeInsets.only(
                                          top: 20,
                                          bottom: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFf2f2f2),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          child: Image.network(
                                            prod.images[0],
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(
                                                      Icons.broken_image,
                                                      size: 50,
                                                    ),
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
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              );
                                            },
                                            // color: Colors.blue.withAlpha(
                                            //   100,
                                            // ), // 100/255 ≈ 39% opacity
                                            // colorBlendMode: BlendMode.darken,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,

                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('\$ ${prod.price}'),
                                            SizedBox(
                                              width: 100,
                                              child: Text(
                                                prod.title,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            final added = await ref
                                                .read(
                                                  cartStateProvider.notifier,
                                                )
                                                .addCart(prod);

                                            if (added) {
                                              if (!context.mounted) return;
                                              AppToast.show(
                                                context,
                                                "Added to cart",

                                                type: ToastTypes.success,
                                                position: ToastPosition.bottom,
                                                duration: Duration(seconds: 5),
                                              );
                                            } else {
                                              if (!context.mounted) return;
                                              AppToast.show(
                                                context,
                                                "Product already added",
                                                type: ToastTypes.success,
                                                position: ToastPosition.bottom,
                                                duration: Duration(seconds: 5),
                                              );
                                            }
                                          },
                                          child: Container(
                                            // padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Color(0xFFe8c9b2),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 25,
                                              color: Color(0xFFe8c9b2),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductImageSwiper extends StatefulWidget {
  final List<String> imageUrls;

  const ProductImageSwiper({Key? key, required this.imageUrls})
    : super(key: key);

  @override
  State<ProductImageSwiper> createState() => _ProductImageSwiperState();
}

class _ProductImageSwiperState extends State<ProductImageSwiper> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image PageView
        SizedBox(
          height: 160,
          // color: Colors.amber,
          child: PageView.builder(
            padEnds: false, // Optional: prevents extra padding at edges
            physics: const BouncingScrollPhysics(),
            pageSnapping: true,
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(3),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    widget.imageUrls[index],
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 10),

        // Dot Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.imageUrls.length,
            (index) => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 8 : 8,
              height: 8,
              decoration: BoxDecoration(
                color:
                    _currentIndex == index
                        ? Color(0xFFff660b)
                        : Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
