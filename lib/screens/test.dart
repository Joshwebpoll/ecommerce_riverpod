import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() => runApp(BannerSwiperApp());

class BannerSwiperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: BannerSwiper());
  }
}

class BannerSwiper extends StatefulWidget {
  @override
  _BannerSwiperState createState() => _BannerSwiperState();
}

class _BannerSwiperState extends State<BannerSwiper> {
  int _currentIndex = 0;
  final List<String> banners = [
    'https://via.placeholder.com/400x200?text=Banner+1',
    'https://via.placeholder.com/400x200?text=Banner+2',
    'https://via.placeholder.com/400x200?text=Banner+3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Banner Swiper")),
      body: Column(
        children: [
          CarouselSlider(
            items:
                banners
                    .map(
                      (url) => Image.network(
                        url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                    .toList(),
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              onPageChanged: (index, reason) {
                setState(() => _currentIndex = index);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                banners.asMap().entries.map((entry) {
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
                              ? Colors.blue
                              : Colors.grey[400],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
