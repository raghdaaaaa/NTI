import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:otlob/core/network/api_client.dart';
import 'package:otlob/features/orders/data/models/delivery_method.dart';
import 'package:otlob/features/orders/data/models/order.dart';
import 'package:otlob/features/orders/data/models/order_request.dart';

class OrderException implements Exception {
  const OrderException(this.message);

  final String message;

  @override
  String toString() => message;
}

class OrderService {
  OrderService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  static final ValueNotifier<int> orderUpdates = ValueNotifier(0);

  final Dio _dio;

  Future<List<OrderModel>> getOrders() async {
    final response = await _request(() => _dio.get('/api/Orders'));
    if (response.data is! List) {
      throw const OrderException('Orders response format is invalid.');
    }
    return (response.data as List).map((item) {
      if (item is! Map) {
        throw const OrderException('Order data is invalid.');
      }
      return OrderModel.fromJson(Map<String, dynamic>.from(item));
    }).toList();
  }

  Future<OrderModel> getOrder(int orderId) async {
    if (orderId <= 0) {
      throw const OrderException('A valid order ID is required.');
    }
    final response = await _request(() => _dio.get('/api/Orders/$orderId'));
    return _parseOrder(response.data);
  }

  Future<List<DeliveryMethodModel>> getDeliveryMethods() async {
    final response = await _request(
      () => _dio.get('/api/Orders/DeliverMethods'),
    );
    if (response.data is! List) {
      throw const OrderException('Delivery methods response is invalid.');
    }
    return (response.data as List).map((item) {
      if (item is! Map) {
        throw const OrderException('Delivery method data is invalid.');
      }
      return DeliveryMethodModel.fromJson(Map<String, dynamic>.from(item));
    }).toList();
  }

  Future<OrderModel> createOrder(OrderRequest request) async {
    final response = await _request(
      () => _dio.post('/api/Orders', data: request.toJson()),
    );
    final order = _parseOrder(response.data);
    orderUpdates.value++;
    return order;
  }

  OrderModel _parseOrder(dynamic data) {
    if (data is Map) {
      return OrderModel.fromJson(Map<String, dynamic>.from(data));
    }
    throw const OrderException('Order response format is invalid.');
  }

  Future<Response<dynamic>> _request(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status != null) {
        final responseData = error.response?.data;
        if (status == 404 &&
            responseData is Map &&
            responseData['statusCode'] == 401) {
          throw const OrderException(
            'The server rejected this order request as unauthorized. Sign in again and retry.',
          );
        }
        throw OrderException(_messageForStatus(status));
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        throw const OrderException(
          'The request timed out. Check your connection and try again.',
        );
      }
      if (error.type == DioExceptionType.connectionError) {
        throw const OrderException(
          'Unable to connect. Check your internet connection and try again.',
        );
      }
      throw const OrderException(
        'Unable to complete the order request. Please try again.',
      );
    }
  }

  String _messageForStatus(int status) {
    switch (status) {
      case 400:
        return 'The order was rejected. Check the delivery method and shipping address.';
      case 401:
        return 'Please sign in to view or place orders.';
      case 403:
        return 'You do not have permission to access these orders.';
      case 404:
        return 'The order or requested order endpoint could not be found.';
      case 500:
      case 502:
      case 503:
      case 504:
        return 'The order service is temporarily unavailable. Please try again.';
      default:
        return 'Order request failed (HTTP $status). Please try again.';
    }
  }
}
