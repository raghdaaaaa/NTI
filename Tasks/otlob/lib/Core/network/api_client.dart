import 'package:dio/dio.dart';

class ApiClient {
  ApiClient._();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://talabat639.runasp.net',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
      contentType: 'application/json',
    ),
  );

  static void setAccessToken(String? token) {
    final normalizedToken = token?.trim();
    if (normalizedToken == null || normalizedToken.isEmpty) {
      dio.options.headers.remove('Authorization');
      return;
    }

    final authorizationValue =
        normalizedToken.toLowerCase().startsWith('bearer ')
        ? normalizedToken
        : <String>['Bearer', normalizedToken].join(' ');
    dio.options.headers.addAll({'Authorization': authorizationValue});
  }
}
