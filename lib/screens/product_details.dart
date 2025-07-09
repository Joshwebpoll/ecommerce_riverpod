import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecommerce/models/product_model.dart';
import 'package:riverpod_ecommerce/provider/cart_provider.dart';
import 'package:riverpod_ecommerce/utils/app_toast.dart';

class ProductDetails extends ConsumerStatefulWidget {
  final Product prod;
  const ProductDetails({super.key, required this.prod});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends ConsumerState<ProductDetails> {
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, size: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ProductImageSwiper(imageUrls: widget.prod.images),
            // Product Details
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.prod.title,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(height: 3),
                  Text(
                    '\$${widget.prod.price}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.prod.description,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(5),

              child: Container(
                child: ElevatedButton(
                  onPressed: () async {
                    final added = await ref
                        .read(cartStateProvider.notifier)
                        .addCart(widget.prod);

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

                  child: Text('Add to Cart', style: TextStyle(fontSize: 14)),
                ),
              ),
            ),
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
        Container(
          height: 300,
          // color: Colors.amber,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return Container(
                // margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(widget.imageUrls[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 16),

        // Dot Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.imageUrls.length,
            (index) => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 24 : 8,
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
