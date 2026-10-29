import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:otlob/core/Extentions/log_extension.dart';
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

  static final ValueNotifier<CustomerBasketModel?> basketUpdates =
      ValueNotifier(null);

  final Dio _dio;

  Future<CustomerBasketModel> getBasket() => _guard(() async {
    final response = await _dio.get('/api/Basket');
    return _parseBasket(response.data);
  });

  Future<CustomerBasketModel> addItem({
    required int productId,
    required int quantity,
  }) async {
    if (productId <= 0 || quantity < 1) {
      throw const CartException('A valid product and quantity are required.');
    }

    final basket = await getBasket();
    final currentQuantity = basket.items
        .where((item) => item.id == productId)
        .fold<int>(0, (total, item) => total + item.quantity);

    return updateItemQuantity(
      productId: productId,
      quantity: currentQuantity + quantity,
    );
  }

  Future<CustomerBasketModel> updateItemQuantity({
    required int productId,
    required int quantity,
  }) {
    if (productId <= 0 || quantity < 1) {
      throw const CartException('A valid product and quantity are required.');
    }

    return _guard(() async {
      final response = await _dio.post(
        '/api/Basket',
        data: {'productId': productId, 'quantity': quantity},
      );
      return _parseBasket(response.data);
    });
  }

  Future<CustomerBasketModel> removeItem(int productId) async {
    if (productId <= 0) {
      throw const CartException('A valid product ID is required.');
    }

    final basket = await getBasket();
    final remaining = basket.items
        .where((item) => item.id != productId)
        .toList();
    if (remaining.length == basket.items.length) return basket;

    try {
      await _guard(() => _dio.delete('/api/Basket'));
      for (final item in remaining) {
        final id = item.id;
        if (id == null) {
          throw const CartException(
            'The basket was cleared, but an item could not be restored.',
          );
        }
        await updateItemQuantity(productId: id, quantity: item.quantity);
      }
      return basketUpdates.value ?? await getBasket();
    } catch (_) {
      try {
        await getBasket();
      } catch (_) {}
      rethrow;
    }
  }

  CustomerBasketModel _parseBasket(dynamic data) {
    if (data is! Map) {
      throw const CartException('Basket response format is invalid.');
    }
    final basket = CustomerBasketModel.fromJson(
      Map<String, dynamic>.from(data),
    );
    basketUpdates.value = basket;
    return basket;
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on CartException {
      rethrow;
    } on DioException catch (error) {
      final serverMessage = _serverMessage(error.response?.data);
      logger(
        'CartService',
        message:
            '${error.requestOptions.method} ${error.requestOptions.uri.path}; '
            'status=${error.response?.statusCode}; error=$serverMessage',
      );
      throw CartException(_messageFor(error, serverMessage));
    } on FormatException {
      throw const CartException('Basket response format is invalid.');
    } on TypeError {
      throw const CartException('Basket response format is invalid.');
    }
  }

  String _messageFor(DioException error, String? serverMessage) {
    final status = error.response?.statusCode;
    final data = error.response?.data;

    if (status == 401 || (data is Map && data['statusCode'] == 401)) {
      return 'Please sign in to update your basket.';
    }

    if (status != null) {
      if (status == 403) {
        return 'You do not have permission to update this basket.';
      }
      if (status == 404) {
        return 'The basket could not be found.';
      }
      if (status >= 500) {
        return 'Basket service unavailable. Please try again later.';
      }
      return serverMessage ?? 'The basket request failed. Please try again.';
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'The request timed out. Check your connection and try again.';
      case DioExceptionType.connectionError:
        return 'Unable to connect. Check your internet connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  String? _serverMessage(dynamic data) {
    if (data is Map) {
      final message = data['message'] ?? data['detail'] ?? data['title'];
      if (message is String && message.isNotEmpty) return message;
    } else if (data is String && data.isNotEmpty && data.length < 240) {
      return data;
    }
    return null;
  }
}
