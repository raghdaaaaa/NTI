import 'package:dio/dio.dart';
import 'package:otlob/core/network/api_client.dart';
import 'package:otlob/features/auth/data/models/login_dto.dart';
import 'package:otlob/features/auth/data/models/register_dto.dart';
import 'package:otlob/features/auth/data/models/user_dto.dart';

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final Dio _dio;

  AuthService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  Future<UserDto> login(LoginDto loginDto) async {
    try {
      final response = await _dio.post(
        '/api/Account/Login',
        data: loginDto.toJson(),
      );

      final user = _parseUserDto(response.data);
      ApiClient.setAccessToken(user.token);
      return user;
    } on AuthException {
      rethrow;
    } on DioException catch (e) {
      throw AuthException(_handleDioError(e));
    } on FormatException {
      throw const AuthException(
        'Invalid response format received from server.',
      );
    } on TypeError {
      throw const AuthException('An unexpected error occurred during login.');
    }
  }

  Future<UserDto> register(RegisterDto registerDto) async {
    try {
      final response = await _dio.post(
        '/api/Account/Register',
        data: registerDto.toJson(),
      );

      final user = _parseUserDto(response.data);
      ApiClient.setAccessToken(user.token);
      return user;
    } on AuthException {
      rethrow;
    } on DioException catch (e) {
      throw AuthException(_handleDioError(e));
    } on FormatException {
      throw const AuthException(
        'Invalid response format received from server.',
      );
    } on TypeError {
      throw const AuthException(
        'An unexpected error occurred during registration.',
      );
    }
  }

  UserDto _parseUserDto(dynamic data) {
    if (data is Map<String, dynamic>) {
      return UserDto.fromJson(data);
    } else if (data is Map) {
      return UserDto.fromJson(Map<String, dynamic>.from(data));
    }
    throw const AuthException('Invalid response format received from server.');
  }

  String _handleDioError(DioException e) {
    final response = e.response;
    if (response != null && response.data != null) {
      final dynamic data = response.data;
      if (data is Map) {
        if (data['message'] != null && data['message'].toString().isNotEmpty) {
          return data['message'].toString();
        }
        if (data['errors'] != null) {
          final errors = data['errors'];
          if (errors is Map) {
            final messages = <String>[];
            for (final value in errors.values) {
              if (value is List) {
                messages.addAll(value.map((v) => v.toString()));
              } else if (value != null) {
                messages.add(value.toString());
              }
            }
            if (messages.isNotEmpty) {
              return messages.join('\n');
            }
          } else if (errors is List && errors.isNotEmpty) {
            return errors.join('\n');
          }
        }
        if (data['title'] != null && data['title'].toString().isNotEmpty) {
          return data['title'].toString();
        }
      } else if (data is String && data.trim().isNotEmpty) {
        return data.trim();
      }

      switch (response.statusCode) {
        case 400:
          return 'Bad request. Please verify your submitted information.';
        case 401:
          return 'Invalid credentials. Please check your email and password.';
        case 403:
          return 'Access denied.';
        case 404:
          return 'Authentication service not found.';
        case 409:
          return 'An account with this email already exists.';
        case 500:
        case 502:
        case 503:
          return 'Server error. Please try again later.';
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please check your network connection.';
      case DioExceptionType.connectionError:
        return 'Network connection error. Please verify your internet access.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      default:
        return 'A network error occurred. Please try again.';
    }
  }
}
