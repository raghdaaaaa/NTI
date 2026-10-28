import 'package:dio/dio.dart';
import 'package:otlob/core/network/api_client.dart';
import 'package:otlob/core/network/api_error.dart';
import 'package:otlob/core/network/auth_session.dart';
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
  final AuthSession _session;

  AuthService({Dio? dio, AuthSession? session})
    : _dio = dio ?? ApiClient.dio,
      _session = session ?? AuthSession.instance;

  Future<UserDto> login(LoginDto loginDto) async {
    try {
      final response = await _dio.post(
        '/api/Account/Login',
        data: loginDto.toJson(),
      );

      final user = _parseUserDto(response.data);
      final token = user.token?.trim();
      if (token == null || token.isEmpty) {
        throw const AuthException(
          'The server did not return an authentication token. Please try again.',
        );
      }
      await _saveToken(token);
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
      final token = user.token?.trim();
      if (token == null || token.isEmpty) {
        await _clearSession();
      } else {
        await _saveToken(token);
      }
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

  Future<void> _saveToken(String token) async {
    try {
      await _session.saveToken(token);
    } on FormatException catch (error) {
      throw AuthException(error.message);
    } catch (_) {
      throw const AuthException(
        'Unable to securely save your session. Please try again.',
      );
    }
  }

  Future<void> _clearSession() async {
    try {
      await _session.clear();
    } catch (_) {
      throw const AuthException(
        'Unable to clear the previous session. Please try again.',
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
    final status = response?.statusCode;
    final detail = safeApiErrorDetail(response?.data);
    if (status != null) {
      switch (status) {
        case 400:
          return detail ??
              'Bad request (HTTP 400). Please verify your submitted information.';
        case 401:
          return detail ??
              'Invalid credentials (HTTP 401). Please check your email and password.';
        case 403:
          return detail ?? 'Access denied (HTTP 403).';
        case 404:
          return detail ?? 'Authentication service not found (HTTP 404).';
        case 409:
          return detail ??
              'An account with this email already exists (HTTP 409).';
        case 500:
          return 'Server error (HTTP 500): ${detail ?? 'The API returned an internal server error.'} Check backend logs for the failing request.';
        case 502:
        case 503:
        case 504:
          return 'Server unavailable (HTTP $status): ${detail ?? 'Please try again later.'}';
        default:
          return 'Request failed (HTTP $status): ${detail ?? 'The server rejected the request.'}';
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
