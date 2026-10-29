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

  Future<CustomerBasketModel> getBasket() async {
    try {
      final response = await _dio.get('/api/Basket');
      final data = response.data;
      if (data == null) {
        throw const CartException('Basket response format is invalid.');
      }
      if (data is! Map) {
        throw const CartException('Basket response format is invalid.');
      }
      final basket = CustomerBasketModel.fromJson(
        Map<String, dynamic>.from(data),
      );
      basketUpdates.value = basket;
      return basket;
    } on CartException {
      rethrow;
    } on DioException catch (error) {
      final serverMessage = _serverMessage(error.response?.data);
      _logRequest(
        error.requestOptions,
        statusCode: error.response?.statusCode,
        errorMessage: serverMessage,
      );
      throw CartException(_messageFor(error, serverMessage));
    } on FormatException {
      throw const CartException('Basket response format is invalid.');
    } on TypeError {
      throw const CartException('Basket response format is invalid.');
    }
  }

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
    if (quantity > 0x7fffffff - currentQuantity) {
      throw const CartException('The requested basket quantity is too large.');
    }

    return updateItemQuantity(
      productId: productId,
      quantity: currentQuantity + quantity,
    );
  }

  Future<CustomerBasketModel> removeItem(int productId) async {
    if (productId <= 0) {
      throw const CartException('A valid product ID is required.');
    }

    final basket = await getBasket();
    final remainingItems = basket.items
        .where((item) => item.id != productId)
        .toList();
    if (remainingItems.length == basket.items.length) return basket;

    try {
      await _dio.delete('/api/Basket');
      basketUpdates.value = const CustomerBasketModel(items: []);

      for (final item in remainingItems) {
        final remainingProductId = item.id;
        if (remainingProductId == null || remainingProductId <= 0) {
          throw const CartException(
            'The basket was cleared, but a remaining product has an invalid ID and could not be restored.',
          );
        }
        await updateItemQuantity(
          productId: remainingProductId,
          quantity: item.quantity,
        );
      }

      return basketUpdates.value ?? await getBasket();
    } on CartException catch (error) {
      await _refreshAfterRemovalFailure(error);
      rethrow;
    } on DioException catch (error) {
      final serverMessage = _serverMessage(error.response?.data);
      _logRequest(
        error.requestOptions,
        statusCode: error.response?.statusCode,
        errorMessage: serverMessage,
      );
      final failure = CartException(_messageFor(error, serverMessage));
      await _refreshAfterRemovalFailure(failure);
      throw failure;
    }
  }

  Future<void> _refreshAfterRemovalFailure(CartException failure) async {
    try {
      await getBasket();
    } on CartException catch (refreshError) {
      throw CartException(
        '${failure.message} The current basket could not be reloaded: ${refreshError.message}',
      );
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
      _logRequest(response.requestOptions, statusCode: response.statusCode);
      final data = response.data;
      if (data is! Map) {
        throw const CartException('Basket response format is invalid.');
      }
      final basket = CustomerBasketModel.fromJson(
        Map<String, dynamic>.from(data),
      );
      basketUpdates.value = basket;
      return basket;
    } on CartException {
      rethrow;
    } on DioException catch (error) {
      final serverMessage = _serverMessage(error.response?.data);
      _logRequest(
        error.requestOptions,
        statusCode: error.response?.statusCode,
        errorMessage: serverMessage,
      );
      throw CartException(_messageFor(error, serverMessage));
    } on FormatException {
      throw const CartException('Basket response format is invalid.');
    } on TypeError {
      throw const CartException('Basket response format is invalid.');
    }
  }

  void _logRequest(
    RequestOptions request, {
    required int? statusCode,
    String? errorMessage,
  }) {
    final requestUri = request.uri;
    final safeUrl = Uri(
      scheme: requestUri.scheme,
      host: requestUri.host,
      port: requestUri.hasPort ? requestUri.port : null,
      path: requestUri.path,
    );
    logger(
      'CartService',
      message:
          '${request.method} $safeUrl; status=${statusCode ?? 'none'}; error=${errorMessage ?? 'none'}',
    );
  }

  String _messageFor(DioException error, [String? serverMessage]) {
    final statusCode = error.response?.statusCode;
    if (statusCode != null) {
      switch (statusCode) {
        case 400:
          return serverMessage ??
              'The basket request was rejected. Check the product and quantity.';
        case 401:
          return serverMessage ?? 'Please sign in to add items to your basket.';
        case 403:
          return serverMessage ??
              'You do not have permission to update this basket.';
        case 404:
          final responseData = error.response?.data;
          if (responseData is Map && responseData['statusCode'] == 401) {
            return 'The basket API rejected this request as unauthorized. Sign in again and retry.';
          }
          return serverMessage == null
              ? 'The basket endpoint or requested resource could not be found.'
              : 'The basket endpoint or requested resource could not be found. $serverMessage';
        case 500:
          return 'Basket request failed (HTTP 500): ${serverMessage ?? 'The server reported an internal error.'} Check backend logs for the failing request.';
        case 502:
        case 503:
        case 504:
          return 'Basket service unavailable (HTTP $statusCode): ${serverMessage ?? 'Please try again later.'}';
        default:
          return serverMessage ??
              'The basket request failed (HTTP $statusCode). Please try again.';
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'The request timed out. Check your connection and try again.';
      case DioExceptionType.connectionError:
        return 'Unable to connect. Check your internet connection and try again.';
      case DioExceptionType.cancel:
        return 'The basket request was cancelled. Please try again.';
      default:
        return 'Unable to add this item right now. Please try again.';
    }
  }

  String? _serverMessage(dynamic data) {
    String? message;
    if (data is Map) {
      final primary = data['message'] ?? data['detail'] ?? data['title'];
      if (primary is String) message = primary;
      if (message == null && data['errors'] is Map) {
        final errors = (data['errors'] as Map).values;
        final messages = errors.expand(
          (value) => value is List ? value : [value],
        );
        message = messages.whereType<String>().join(' ');
      } else if (message == null && data['errors'] is List) {
        message = (data['errors'] as List).whereType<String>().join(' ');
      }
    } else if (data is String) {
      message = data;
    }

    if (message == null) return null;
    final sanitized = message
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'[\r\n\t]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (sanitized.isEmpty ||
        sanitized.length > 240 ||
        RegExp(
          r'(stack trace|exception:|dioexception| at [\w.]+\(|password|(?:access[_ -]?)?token|authorization:|bearer\s+\S+)',
          caseSensitive: false,
        ).hasMatch(sanitized)) {
      return null;
    }

    return sanitized
        .replaceAll(
          RegExp(
            r'\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b',
            caseSensitive: false,
          ),
          '[redacted]',
        )
        .replaceAll(
          RegExp(r'\bBearer\s+\S+', caseSensitive: false),
          'Bearer [redacted]',
        );
  }
}
