import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otlob/core/network/api_client.dart';
import 'package:otlob/core/network/auth_session.dart';
import 'package:otlob/core/routes/app_routes.dart';
import 'package:otlob/features/auth/data/models/login_dto.dart';
import 'package:otlob/features/auth/data/services/auth_service.dart';
import 'package:otlob/features/auth/presentation/screens/log_in.dart';
import 'package:otlob/features/cart/data/services/cart_service.dart';
import 'package:otlob/main.dart';

void main() {
  testWidgets('starts on Login when no token is stored', (tester) async {
    final storage = _MemoryTokenStorage();

    await tester.pumpWidget(MyApp(session: AuthSession(storage: storage)));
    await tester.pumpAndSettle();

    expect(find.text('Enter your email'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(storage.token, isNull);
  });

  testWidgets('successful login stores the token and opens Home', (
    tester,
  ) async {
    final storage = _MemoryTokenStorage();
    final session = AuthSession(storage: storage);
    final dio = Dio(BaseOptions(baseUrl: 'https://talabat639.runasp.net'))
      ..httpClientAdapter = _LoginAdapter();

    await tester.pumpWidget(
      MaterialApp(
        home: LogInScreen(
          authService: AuthService(dio: dio, session: session),
        ),
        onGenerateRoute: (settings) => settings.name == AppRoutes.main
            ? MaterialPageRoute<void>(
                builder: (_) =>
                    const Scaffold(body: Text('Authenticated Home')),
              )
            : null,
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'ada@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'Passw0rd!');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Authenticated Home'), findsOneWidget);
    expect(storage.token, 'test-token');
    expect(ApiClient.dio.options.headers['Authorization'], 'Bearer test-token');
    dio.close();
    ApiClient.setAccessToken(null);
  });

  testWidgets('failed login stays on Login and displays an error', (
    tester,
  ) async {
    final dio = Dio(BaseOptions(baseUrl: 'https://talabat639.runasp.net'))
      ..httpClientAdapter = _LoginAdapter(statusCode: 401);

    await tester.pumpWidget(
      MaterialApp(
        home: LogInScreen(
          authService: AuthService(
            dio: dio,
            session: AuthSession(storage: _MemoryTokenStorage()),
          ),
        ),
        onGenerateRoute: (settings) => settings.name == AppRoutes.main
            ? MaterialPageRoute<void>(
                builder: (_) =>
                    const Scaffold(body: Text('Authenticated Home')),
              )
            : null,
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'ada@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'Passw0rd!');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.byType(LogInScreen), findsOneWidget);
    expect(find.text('Authenticated Home'), findsNothing);
    expect(find.text('Invalid credentials'), findsOneWidget);
    dio.close();
    ApiClient.setAccessToken(null);
  });

  test('restores valid tokens and rejects expired JWTs', () async {
    final storage = _MemoryTokenStorage()
      ..token = _jwtToken(DateTime.now().toUtc().add(const Duration(hours: 1)));
    final session = AuthSession(storage: storage);

    expect(await session.restoreSession(), isTrue);
    expect(
      ApiClient.dio.options.headers['Authorization'],
      startsWith('Bearer '),
    );

    storage.token = _jwtToken(
      DateTime.now().toUtc().subtract(const Duration(minutes: 1)),
    );
    expect(await session.restoreSession(), isFalse);
    expect(storage.token, isNull);
    expect(ApiClient.dio.options.headers.containsKey('Authorization'), isFalse);
  });

  test(
    'shared API client scopes authorization to protected API paths',
    () async {
      final session = AuthSession(storage: _MemoryTokenStorage());
      await session.saveToken('test-token');
      final adapter = _BasketAdapter();
      ApiClient.dio.httpClientAdapter = adapter;

      await CartService().getBasket();
      await ApiClient.dio.get('/api/Products');
      await ApiClient.dio.post(
        '/api/Account/Login',
        data: {'email': 'test@example.com', 'password': 'not-a-real-password'},
      );
      await ApiClient.dio.get('/api/Account/emailExisits');
      await ApiClient.dio.get('/api/Account');
      await ApiClient.dio.get('/api/Orders');
      await ApiClient.dio.get('/api/Orders/DeliverMethods');

      expect(adapter.authorizationByPath['/api/Basket'], startsWith('Bearer '));
      expect(
        adapter.authorizationByPath['/api/Account'],
        startsWith('Bearer '),
      );
      expect(adapter.authorizationByPath['/api/Orders'], startsWith('Bearer '));
      expect(
        adapter.authorizationByPath['/api/Orders/DeliverMethods'],
        startsWith('Bearer '),
      );
      expect(adapter.authorizationByPath['/api/Products'], isNull);
      expect(adapter.authorizationByPath['/api/Account/Login'], isNull);
      expect(adapter.authorizationByPath['/api/Account/emailExisits'], isNull);

      ApiClient.setAccessToken('Bearer ');
      await ApiClient.dio.get('/api/Basket');
      expect(adapter.authorizationByPath['/api/Basket'], isNull);
      await session.clear();
    },
  );

  test('authentication errors preserve safe HTTP 500 details', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://talabat639.runasp.net'))
      ..httpClientAdapter = _LoginAdapter(
        statusCode: 500,
        errorResponse: {
          'message': 'Database temporarily unavailable; password=secret; token=private-token',
        },
      );

    await expectLater(
      AuthService(
        dio: dio,
        session: AuthSession(storage: _MemoryTokenStorage()),
      ).login(
        const LoginDto(email: 'test@example.com', password: 'not-a-secret'),
      ),
      throwsA(
        isA<AuthException>().having(
          (error) => error.message,
          'message',
          allOf(
            contains('HTTP 500'),
            contains('Database temporarily unavailable'),
            isNot(contains('secret')),
            isNot(contains('private-token')),
          ),
        ),
      ),
    );
    dio.close();
  });

  test('shared API client sends the saved bearer token to Basket', () async {
    final session = AuthSession(storage: _MemoryTokenStorage());
    await session.saveToken('test-token');
    final adapter = _BasketAdapter();
    ApiClient.dio.httpClientAdapter = adapter;

    await CartService().getBasket();

    expect(adapter.authorization, 'Bearer test-token');
    await session.clear();
    ApiClient.dio.close();
  });
}

String _jwtToken(DateTime expiration) {
  final payload = base64Url
      .encode(
        utf8.encode(
          jsonEncode({'exp': expiration.millisecondsSinceEpoch ~/ 1000}),
        ),
      )
      .replaceAll('=', '');
  return 'header.$payload.signature';
}

class _MemoryTokenStorage implements AccessTokenStorage {
  String? token;

  @override
  Future<String?> readToken() async => token;

  @override
  Future<void> writeToken(String token) async {
    this.token = token;
  }

  @override
  Future<void> deleteToken() async {
    token = null;
  }
}

class _LoginAdapter implements HttpClientAdapter {
  _LoginAdapter({this.statusCode = 200, this.errorResponse});

  final int statusCode;
  final Map<String, dynamic>? errorResponse;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final response = statusCode == 200
        ? {
            'displayName': 'Ada',
            'email': 'ada@example.com',
            'token': 'test-token',
          }
        : errorResponse ?? {'message': 'Invalid credentials'};
    return ResponseBody.fromString(
      jsonEncode(response),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _BasketAdapter implements HttpClientAdapter {
  String? authorization;
  final authorizationByPath = <String, String?>{};

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    authorizationByPath[options.uri.path] =
        options.headers['Authorization'] as String?;
    if (options.uri.path == '/api/Basket') {
      authorization = options.headers['Authorization'] as String?;
    }
    return ResponseBody.fromString(
      jsonEncode({'id': 'basket', 'items': []}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
