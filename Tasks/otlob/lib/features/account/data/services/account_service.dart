import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:otlob/core/network/api_error.dart';
import 'package:otlob/core/network/api_client.dart';
import 'package:otlob/features/account/data/models/address_dto.dart';
import 'package:otlob/features/auth/data/models/user_dto.dart';

class AccountException implements Exception {
  const AccountException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AccountService {
  AccountService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  static final ValueNotifier<int> accountUpdates = ValueNotifier(0);

  final Dio _dio;

  Future<UserDto> getAccount() async {
    final response = await _request(() => _dio.get('/api/Account'));
    return _parseMap(
      response,
      UserDto.fromJson,
      'Account response is invalid.',
    );
  }

  Future<AddressDto> getAddress() async {
    final response = await _request(() => _dio.get('/api/Account/Address'));
    return _parseMap(
      response,
      AddressDto.fromJson,
      'Address response is invalid.',
    );
  }

  Future<AddressDto> updateAddress(AddressDto address) async {
    final response = await _request(
      () => _dio.put('/api/Account/Address', data: address.toJson()),
    );
    final updated = _parseMap(
      response,
      AddressDto.fromJson,
      'Address response is invalid.',
    );
    accountUpdates.value++;
    return updated;
  }

  Future<bool> emailExists(String email) async {
    final response = await _request(
      () => _dio.get(
        '/api/Account/emailExisits',
        queryParameters: {'email': email},
      ),
    );
    if (response.data is bool) return response.data as bool;
    throw const AccountException('Email availability response is invalid.');
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
          throw const AccountException(
            'The API returned HTTP 404 with an error payload reporting 401. Sign in and retry the account request.',
          );
        }
        if (status == 500) {
          final detail = safeApiErrorDetail(responseData);
          throw AccountException(
            'Account request failed (HTTP 500): ${detail ?? 'The server reported an internal error.'} Check backend logs for the failing request.',
          );
        }
        throw AccountException(
          'Account request failed (HTTP $status). Please try again.',
        );
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        throw const AccountException(
          'The request timed out. Check your connection and try again.',
        );
      }
      if (error.type == DioExceptionType.connectionError) {
        throw const AccountException(
          'Unable to connect. Check your internet connection and try again.',
        );
      }
      throw const AccountException(
        'Unable to complete the account request. Please try again.',
      );
    }
  }

  T _parseMap<T>(
    Response<dynamic> response,
    T Function(Map<String, dynamic>) parse,
    String message,
  ) {
    if (response.data is Map) {
      return parse(Map<String, dynamic>.from(response.data as Map));
    }
    throw AccountException(message);
  }
}
