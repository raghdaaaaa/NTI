import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:otlob/core/network/api_client.dart';
import 'package:otlob/features/home/data/models/product_model.dart';

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
  ExploreService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<List<CategoryModel>> getCategories() async {
    try {
      final res = await _dio.get('/api/Products/categories');
      debugPrint('Categories response: ${res.data}');
      final list = _asList(res.data);
      return [
        for (var i = 0; i < list.length; i++)
          CategoryModel.fromJson(
            _asMap(list[i]),
            _bgColors[i % _bgColors.length],
          ),
      ];
    } on DioException catch (e) {
      throw Exception(
        '${e.type} | status=${e.response?.statusCode} | ${e.message}',
      );
    }
  }

  Future<List<BrandModel>> getBrands() async {
    try {
      final res = await _dio.get('/api/Products/brands');
      debugPrint('Brands response: ${res.data}');
      final list = _asList(res.data);
      return list
          .map<BrandModel>((e) => BrandModel.fromJson(_asMap(e)))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        '${e.type} | status=${e.response?.statusCode} | ${e.message}',
      );
    }
  }

  Future<List<ProductModel>> getFilteredProducts({
    int? categoryId,
    int? brandId,
    String? search,
    String? sort,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (categoryId != null) queryParams['categoryId'] = categoryId;
      if (brandId != null) queryParams['brandId'] = brandId;
      if (sort != null && sort.isNotEmpty) queryParams['sort'] = sort;
      if (search != null && search.trim().isNotEmpty) {
        queryParams['Search'] = search.trim();
      }
      final res = await _dio.get('/api/Products', queryParameters: queryParams);
      debugPrint('Filtered Products response: ${res.data}');
      final list = _productList(res.data);
      return list.map((e) => ProductModel.fromJson(_asMap(e))).toList();
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to load products');
    }
  }

  Future<List<ProductModel>> getProducts() async {
    try {
      final res = await _dio.get('/api/Products');
      debugPrint('Products response: ${res.data}');
      final list = _productList(res.data);
      return list.map((e) => ProductModel.fromJson(_asMap(e))).toList();
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to load products');
    }
  }

  List<dynamic> _asList(dynamic response) {
    if (response is List) return response;
    if (response is Map && response['data'] is List) {
      return response['data'] as List;
    }
    throw const FormatException('API list response format is invalid.');
  }

  List<dynamic> _productList(dynamic response) {
    final list = _asList(response);
    if (list.isNotEmpty &&
        list.first is Map &&
        (list.first as Map).containsKey('page_Index')) {
      final pageData = (list.first as Map)['data'];
      if (pageData is List) return pageData;
      throw const FormatException('Products page data is invalid.');
    }
    return list;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    throw const FormatException('API item response format is invalid.');
  }
}
