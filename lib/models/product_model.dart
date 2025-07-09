import 'package:riverpod_ecommerce/models/category_model.dart';

class Product {
  final int id;
  final String title;
  final String slug;
  final double price;
  final String description;
  final Category category;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: Category.fromJson(json['category']),
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'price': price,
      'description': description,
      'category': category.toJson(),
      'images': images,
    };
  }

  @override
  String toString() {
    return 'Product(id: $id, title: $title, price: $price, category: ${category.name}, images: $images)';
  }
}
