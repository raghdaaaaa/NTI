import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final String emoji;
  final Color bgColor;

  const CategoryModel({
    required this.name,
    required this.emoji,
    required this.bgColor,
  });
}

const categories = [
  CategoryModel(name: 'Frappuccino', emoji: '🥤', bgColor: Color(0xFFFDECEC)),
  CategoryModel(name: 'Latte', emoji: '☕', bgColor: Color(0xFFFEF6E0)),
  CategoryModel(name: 'Mocha', emoji: '🍫', bgColor: Color(0xFFF3F4F6)),
  CategoryModel(name: 'Macchiato', emoji: '☕', bgColor: Color(0xFFF0EEFB)),
  CategoryModel(name: 'Matcha', emoji: '🍵', bgColor: Color(0xFFE6F7EE)),
  CategoryModel(name: 'Cake', emoji: '🍰', bgColor: Color(0xFFFDEEF1)),
  CategoryModel(name: 'Donuts', emoji: '🍩', bgColor: Color(0xFFFFF1E6)),
  CategoryModel(name: 'Salad', emoji: '🥗', bgColor: Color(0xFFE8F1FD)),
];
