import 'package:dio/dio.dart';
import 'package:otlob/core/network/api_client.dart';
import 'package:otlob/features/cart/data/models/cart.dart';

class CartException implements Exception {
  const CartException(this.message);

  final String message;

  @override
  String toString() => message;
}

class CartService {
  CartService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<CustomerBasketModel> getBasket() async {
    try {
      final response = await _dio.get('/api/Basket');
      final data = response.data;
      if (data == null) {
        return const CustomerBasketModel(items: []);
      }
      if (data is! Map) {
        throw const CartException('Basket response format is invalid.');
      }
      return CustomerBasketModel.fromJson(Map<String, dynamic>.from(data));
    } on CartException {
      rethrow;
    } on DioException catch (error) {
      throw CartException(_messageFor(error));
    } on FormatException {
      throw const CartException('Basket response format is invalid.');
    } on TypeError {
      throw const CartException('Basket response format is invalid.');
    }
  }

  Future<CustomerBasketModel> updateItemQuantity({
    required int productId,
    required int quantity,
  }) async {
    if (productId <= 0 || quantity < 1) {
      throw const CartException('A valid product and quantity are required.');
    }

    try {
      final response = await _dio.post(
        '/api/Basket',
        data: {'productId': productId, 'quantity': quantity},
      );
      final data = response.data;
      if (data is! Map) {
        throw const CartException('Basket response format is invalid.');
      }
      return CustomerBasketModel.fromJson(Map<String, dynamic>.from(data));
    } on CartException {
      rethrow;
    } on DioException catch (error) {
      throw CartException(_messageFor(error));
    } on FormatException {
      throw const CartException('Basket response format is invalid.');
    } on TypeError {
      throw const CartException('Basket response format is invalid.');
    }
  }

  String _messageFor(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode != null) {
      if (statusCode == 401 || statusCode == 403) {
        return 'The basket service requires an authorized session.';
      }
      return 'Basket request failed (HTTP $statusCode).';
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return 'Unable to connect. Check your connection and try again.';
    }
    return 'Unable to load the basket. Please try again.';
  }
}
