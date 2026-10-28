import 'package:dio/dio.dart';
import 'package:otlob/core/network/api_client.dart';
import 'package:otlob/features/home/data/models/product_model.dart';

class ProductDetailsException implements Exception {
  const ProductDetailsException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ProductDetailsService {
  ProductDetailsService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<ProductModel> getProductDetails(String productId) async {
    final id = int.tryParse(productId);
    if (id == null || id <= 0) {
      throw const ProductDetailsException('Product ID is unavailable.');
    }

    try {
      final response = await _dio.get('/api/Products/$id');
      final data = response.data;
      if (data is! Map) {
        throw const ProductDetailsException('Product details are unavailable.');
      }

      final product = ProductModel.fromJson(Map<String, dynamic>.from(data));
      if (product.id.isEmpty) {
        throw const ProductDetailsException('Product details are unavailable.');
      }
      return product;
    } on ProductDetailsException {
      rethrow;
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        throw const ProductDetailsException('Product not found.');
      }
      if (error.response != null) {
        throw const ProductDetailsException(
          'Unable to load product details. Please try again.',
        );
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        throw const ProductDetailsException(
          'The request timed out. Check your connection and try again.',
        );
      }
      throw const ProductDetailsException(
        'Unable to connect. Check your connection and try again.',
      );
    } on FormatException {
      throw const ProductDetailsException('Product details are unavailable.');
    } on TypeError {
      throw const ProductDetailsException('Product details are unavailable.');
    }
  }
}
