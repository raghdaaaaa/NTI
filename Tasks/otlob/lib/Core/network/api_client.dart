import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:otlob/core/network/api_error.dart';

class ApiClient {
  ApiClient._();

  static String? _accessToken;

  static final Dio dio = _createDio();

  static Dio _createDio() {
    final client = Dio(
      BaseOptions(
        baseUrl: 'https://talabat639.runasp.net',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
        contentType: 'application/json',
      ),
    );
    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers.remove('Authorization');
          final token = _accessToken;
          if (token != null && _requiresAuthentication(options.uri.path)) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          final request = error.requestOptions;
          final requestUri = request.uri;
          final safeUrl = Uri(
            scheme: requestUri.scheme,
            host: requestUri.host,
            port: requestUri.hasPort ? requestUri.port : null,
            path: requestUri.path,
          );
          final detail = safeApiErrorDetail(error.response?.data);
          debugPrint(
            '[API] ${request.method} $safeUrl; '
            'queryKeys=${request.queryParameters.keys.toList()}; '
            'payloadKeys=${_payloadFieldNames(request.data)}; '
            'status=${error.response?.statusCode ?? 'none'}; '
            'type=${error.type.name}; '
            'detail=${detail ?? 'none'}',
          );
          handler.next(error);
        },
      ),
    );
    return client;
  }

  static List<String> _payloadFieldNames(dynamic data) {
    if (data is Map) return data.keys.map((key) => key.toString()).toList();
    if (data is FormData) {
      return data.fields.map((field) => field.key).toList();
    }
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) {
          return decoded.keys.map((key) => key.toString()).toList();
        }
      } on FormatException {
        return const ['String'];
      }
    }
    return data == null ? const [] : [data.runtimeType.toString()];
  }

  static void setAccessToken(String? token) {
    final normalizedToken = token?.trim();
    if (normalizedToken == null || normalizedToken.isEmpty) {
      _accessToken = null;
      dio.options.headers.remove('Authorization');
      return;
    }

    final bareToken = normalizedToken.replaceFirst(
      RegExp(r'^Bearer\s+', caseSensitive: false),
      '',
    );
    _accessToken =
        bareToken.isEmpty ||
            bareToken.toLowerCase() == 'bearer' ||
            RegExp(r'\s').hasMatch(bareToken)
        ? null
        : bareToken;
    if (_accessToken == null) {
      dio.options.headers.remove('Authorization');
    } else {
      dio.options.headers['Authorization'] = 'Bearer $_accessToken';
    }
  }

  static bool _requiresAuthentication(String path) {
    final normalizedPath = path.toLowerCase();
    if (normalizedPath == '/api/account/login' ||
        normalizedPath == '/api/account/register' ||
        normalizedPath == '/api/account/emailexisits') {
      return false;
    }

    return normalizedPath == '/api/basket' ||
        normalizedPath.startsWith('/api/basket/') ||
        normalizedPath == '/api/orders' ||
        normalizedPath.startsWith('/api/orders/') ||
        normalizedPath == '/api/account' ||
        normalizedPath.startsWith('/api/account/');
  }
}
