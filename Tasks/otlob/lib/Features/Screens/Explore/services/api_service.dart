import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:otlob/Core/network/api_client.dart';
import 'package:otlob/Features/Screens/Home/Models/product_model.dart';

import '../models/categ.dart';
import '../models/brands.dart';

const _bgColors = [
  Color(0xFFFDECEC),
  Color(0xFFFEF6E0),
  Color(0xFFF3F4F6),
  Color(0xFFF0EEFB),
  Color(0xFFE6F7EE),
  Color(0xFFFDEEF1),
  Color(0xFFFFF1E6),
  Color(0xFFE8F1FD),
];

class ExploreService {
  Future<List<CategoryModel>> getCategories() async {
    try {
      final res = await ApiClient.dio.get('/api/Products/categories');
      debugPrint('Categories response: ${res.data}');
      final list = res.data is List
          ? res.data
          : (res.data['data'] as List? ?? []);
      return [
        for (var i = 0; i < list.length; i++)
          CategoryModel.fromJson(list[i], _bgColors[i % _bgColors.length]),
      ];
    } on DioException catch (e) {
      throw Exception(
        '${e.type} | status=${e.response?.statusCode} | ${e.message}',
      );
    } catch (e) {
      throw Exception('PARSE ERROR: $e');
    }
  }

  Future<List<BrandModel>> getBrands() async {
    try {
      final res = await ApiClient.dio.get('/api/Products/brands');
      debugPrint('Brands response: ${res.data}');
      final list = res.data is List
          ? res.data
          : (res.data['data'] as List? ?? []);
      return list.map<BrandModel>((e) => BrandModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        '${e.type} | status=${e.response?.statusCode} | ${e.message}',
      );
    } catch (e) {
      throw Exception('PARSE ERROR: $e');
    }
  }

  Future<List<ProductModel>> getFilteredProducts({
    int? categoryId,
    int? brandId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (categoryId != null) queryParams['categoryId'] = categoryId;
      if (brandId != null) queryParams['brandId'] = brandId;
      final res = await ApiClient.dio.get(
        '/api/Products',
        queryParameters: queryParams,
      );
      debugPrint('Filtered Products response: ${res.data}');
      final data = res.data;
      final list = data is List ? data : (data['data'] as List? ?? []);
      return list.map((e) => ProductModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to load products');
    }
  }

  Future<List<ProductModel>> getProducts() async {
    try {
      final res = await ApiClient.dio.get('/api/Products');
      debugPrint('Products response: ${res.data}');
      final data = res.data;
      final list = data is List ? data : (data['data'] as List? ?? []);
      return list.map((e) => ProductModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to load products');
    }
  }
}
