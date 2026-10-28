import 'package:flutter/material.dart';

const _categoryEmojis = {
  'frappuccino': '🥤',
  'latte': '☕',
  'mocha': '🍫',
  'macchiato': '☕',
  'matcha': '🍵',
  'cake': '🍰',
  'donuts': '🍩',
  'salad': '🥗',
};

class CategoryModel {
  final int id;
  final String name;
  final String? imageUrl;
  final Color bgColor;

  const CategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.bgColor,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json, Color bg) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: _resolveImageUrl(json['pictureUrl']?.toString()),
      bgColor: bg,
    );
  }

  static String? _resolveImageUrl(String? pictureUrl) {
    if (pictureUrl == null || pictureUrl.trim().isEmpty) return null;
    return Uri.parse('https://talabat639.runasp.net')
        .resolve(pictureUrl)
        .toString();
  }

  String get emoji => _categoryEmojis[name.toLowerCase().trim()] ?? '🍽️';
}
