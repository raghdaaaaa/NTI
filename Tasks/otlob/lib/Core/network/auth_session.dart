import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:otlob/core/network/api_client.dart';

abstract interface class AccessTokenStorage {
  Future<String?> readToken();
  Future<void> writeToken(String token);
  Future<void> deleteToken();
}

class SecureAccessTokenStorage implements AccessTokenStorage {
  const SecureAccessTokenStorage();

  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'access_token';

  @override
  Future<String?> readToken() => _storage.read(key: _tokenKey);

  @override
  Future<void> writeToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  @override
  Future<void> deleteToken() => _storage.delete(key: _tokenKey);
}

class AuthSession {
  AuthSession({AccessTokenStorage? storage})
    : _storage = storage ?? const SecureAccessTokenStorage();

  static final AuthSession instance = AuthSession();

  final AccessTokenStorage _storage;

  Future<bool> restoreSession() async {
    ApiClient.setAccessToken(null);
    final token = (await _storage.readToken())?.trim();
    if (!isValidToken(token)) {
      if (token != null && token.isNotEmpty) {
        await _storage.deleteToken();
      }
      return false;
    }

    ApiClient.setAccessToken(token);
    return true;
  }

  Future<void> saveToken(String token) async {
    final normalizedToken = token.trim();
    if (!isValidToken(normalizedToken)) {
      throw const FormatException('A valid authentication token is required.');
    }

    await _storage.writeToken(normalizedToken);
    ApiClient.setAccessToken(normalizedToken);
  }

  Future<void> clear() async {
    ApiClient.setAccessToken(null);
    await _storage.deleteToken();
  }

  static bool isValidToken(String? token, {DateTime? now}) {
    if (token == null || token.isEmpty) return false;

    final normalizedToken = token.trim();
    final bareToken = normalizedToken.replaceFirst(
      RegExp(r'^Bearer\s+', caseSensitive: false),
      '',
    );
    if (bareToken.isEmpty ||
        bareToken.toLowerCase() == 'bearer' ||
        RegExp(r'\s').hasMatch(bareToken)) {
      return false;
    }

    final segments = bareToken.split('.');
    if (segments.length != 3) return true;

    try {
      final normalizedPayload = base64Url.normalize(segments[1]);
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(normalizedPayload)),
      );
      if (payload is! Map<String, dynamic>) return false;

      final expiration = payload['exp'];
      if (expiration == null) return true;
      if (expiration is! num) return false;

      final expirationTime = DateTime.fromMillisecondsSinceEpoch(
        (expiration * 1000).round(),
        isUtc: true,
      );
      return expirationTime.isAfter((now ?? DateTime.now()).toUtc());
    } on FormatException {
      return false;
    } on TypeError {
      return false;
    }
  }
}
