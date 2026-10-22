import 'package:flutter/material.dart';

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
      imageUrl: null,
      bgColor: bg,
    );
  }
}
