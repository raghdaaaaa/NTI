import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otlob/core/network/api_client.dart';
import 'package:otlob/core/network/auth_session.dart';
import 'package:otlob/core/routes/app_routes.dart';
import 'package:otlob/core/shared/bottom_nav.dart';
import 'package:otlob/features/auth/data/models/login_dto.dart';
import 'package:otlob/features/auth/data/services/auth_service.dart';
import 'package:otlob/features/auth/presentation/screens/log_in.dart';
import 'package:otlob/features/cart/data/services/cart_service.dart';
import 'package:otlob/features/cart/presentation/screens/cart.dart';
import 'package:otlob/main.dart';

void main() {
  testWidgets('starts on Login without a stored token and opens Sign Up', (
    tester,
  ) async {
    final storage = _MemoryTokenStorage();

    await tester.pumpWidget(MyApp(session: AuthSession(storage: storage)));
    await tester.pumpAndSettle();

    expect(find.byType(LogInScreen), findsOneWidget);
    expect(find.text('Enter your email'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(storage.token, isNull);
    expect(ApiClient.hasAccessToken, isFalse);

    for (final route in [
      AppRoutes.main,
      AppRoutes.explore,
      AppRoutes.cart,
      AppRoutes.orders,
      AppRoutes.checkout,
      AppRoutes.details,
      AppRoutes.filter,
      AppRoutes.filterb,
      AppRoutes.filterProducts,
      AppRoutes.debug,
    ]) {
      Navigator.of(tester.element(find.byType(LogInScreen)))
          .pushReplacementNamed(route);
      await tester.pumpAndSettle();
      expect(find.byType(LogInScreen), findsOneWidget);
      expect(ApiClient.hasAccessToken, isFalse);
    }

    await tester.ensureVisible(find.text('Sign Up'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Create an account'), findsOneWidget);
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

  testWidgets('startup restores a saved session without showing Login', (
    tester,
  ) async {
    final storage = _MemoryTokenStorage()..token = 'test-token';
    final session = AuthSession(storage: storage);
    ApiClient.dio.httpClientAdapter = _BasketAdapter();

    await tester.pumpWidget(MyApp(session: session));
    await tester.pumpAndSettle();

    expect(find.byType(LogInScreen), findsNothing);
    expect(find.byType(MainShell), findsOneWidget);
    expect(ApiClient.hasAccessToken, isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
    await session.clear();
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

  testWidgets('Cart fetches, updates and removes returned basket products', (
    tester,
  ) async {
    final session = AuthSession(storage: _MemoryTokenStorage());
    await session.saveToken('test-token');
    CartService.basketUpdates.value = null;
    final adapter = _BasketAdapter(includeProduct: true);
    ApiClient.dio.httpClientAdapter = adapter;

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: CartScreen())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cake'), findsWidgets);
    expect(find.text('Bakery · Dessert'), findsOneWidget);
    expect(find.text('25.50 EGP'), findsWidgets);
    expect(CartService.basketUpdates.value?.items.single.id, 7);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(CartService.basketUpdates.value?.items.single.quantity, 4);
    expect(find.textContaining('34 EGP'), findsWidgets);

    await tester.tap(find.byIcon(Icons.remove));
    await tester.pumpAndSettle();
    expect(CartService.basketUpdates.value?.items.single.quantity, 3);
    expect(find.text('25.50 EGP'), findsWidgets);

    await tester.tap(find.byTooltip('Remove Cake'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('only supports clearing the entire basket'),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(TextButton, 'Remove'));
    await tester.pumpAndSettle();

    expect(find.text('Your cart is empty.'), findsOneWidget);
    expect(CartService.basketUpdates.value?.items, isEmpty);
    expect(
      adapter.basketRequests
          .map((request) => '${request.method} ${request.uri.path}')
          .toList(),
      [
        'GET /api/Basket',
        'POST /api/Basket',
        'POST /api/Basket',
        'GET /api/Basket',
        'DELETE /api/Basket',
      ],
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await session.clear();
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
  _BasketAdapter({this.includeProduct = false}) {
    if (includeProduct) {
      _basketItems.add({
        'id': 7,
        'productName': 'Cake',
        'brand': 'Bakery',
        'category': 'Dessert',
        'price': 8.5,
        'quantity': 3,
        'pictureUrl': null,
      });
    }
  }

  final bool includeProduct;
  final basketRequests = <RequestOptions>[];
  final _basketItems = <Map<String, dynamic>>[];
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
      basketRequests.add(options);
      authorization = options.headers['Authorization'] as String?;
      if (options.method == 'POST') {
        final bytes = await requestStream!.fold<List<int>>(
          [],
          (buffer, chunk) => buffer..addAll(chunk),
        );
        final body = Map<String, dynamic>.from(
          jsonDecode(utf8.decode(bytes)) as Map,
        );
        final item = _basketItems.firstWhere(
          (entry) => entry['id'] == body['productId'],
        );
        item['quantity'] = body['quantity'];
      } else if (options.method == 'DELETE') {
        _basketItems.clear();
      }

      final response = options.method == 'DELETE'
          ? null
          : {'id': 'basket', 'items': _basketItems};
      return ResponseBody.fromString(
        jsonEncode(response),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }
    return ResponseBody.fromString(
      jsonEncode(_response(options.uri.path)),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  dynamic _response(String path) {
    if (path == '/api/Products/categories' ||
        path == '/api/Products/brands' ||
        path == '/api/Orders' ||
        path == '/api/Orders/DeliverMethods') {
      return [];
    }
    if (path == '/api/Products') {
      return {'page_Index': 1, 'page_Size': 10, 'count': 0, 'data': []};
    }
    if (path == '/api/Account') {
      return {'displayName': 'Ada', 'email': 'ada@example.com'};
    }
    if (path == '/api/Account/Address') {
      return {
        'firstName': 'Ada',
        'lastName': 'Lovelace',
        'street': '1 Main Street',
        'city': 'Cairo',
        'country': 'Egypt',
      };
    }
    return {};
  }

  @override
  void close({bool force = false}) {}
}
