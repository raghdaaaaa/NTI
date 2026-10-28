import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otlob/core/network/api_client.dart';
import 'package:otlob/core/network/auth_session.dart';
import 'package:otlob/features/account/data/models/address_dto.dart';
import 'package:otlob/features/account/data/services/account_service.dart';
import 'package:otlob/features/auth/data/models/login_dto.dart';
import 'package:otlob/features/auth/data/models/register_dto.dart';
import 'package:otlob/features/auth/data/services/auth_service.dart';
import 'package:otlob/features/cart/data/services/cart_service.dart';
import 'package:otlob/features/details/data/services/product_details_service.dart';
import 'package:otlob/features/explore/data/services/api_service.dart';
import 'package:otlob/features/home/data/services/home_service.dart';
import 'package:otlob/features/orders/data/models/order_request.dart';
import 'package:otlob/features/orders/data/services/order_service.dart';

void main() {
  test('parses the Swagger array-wrapped product pagination schema', () async {
    final adapter = _ApiAdapter(productsAsPageList: true);
    final dio = Dio(BaseOptions(baseUrl: 'https://talabat639.runasp.net'))
      ..httpClientAdapter = adapter;

    final result = await HomeService(dio: dio)
        .getProductsPagination(pageIndex: 2);

    expect(result.pageIndex, 2);
    expect(result.pageSize, 10);
    expect(result.count, 1);
    expect(result.data.single.id, '7');
    dio.close();
  });

  test(
    'uses documented API paths, methods, queries, and DTO payloads',
    () async {
      final adapter = _ApiAdapter();
      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://talabat639.runasp.net',
          contentType: Headers.jsonContentType,
        ),
      )..httpClientAdapter = adapter;

      final auth = AuthService(
        dio: dio,
        session: AuthSession(storage: _MemoryTokenStorage()),
      );
      final account = AccountService(dio: dio);
      final basket = CartService(dio: dio);
      final explore = ExploreService(dio: dio);
      final home = HomeService(dio: dio);
      final productDetails = ProductDetailsService(dio: dio);
      final orders = OrderService(dio: dio);
      const address = AddressDto(
        firstName: 'Ada',
        lastName: 'Lovelace',
        street: '1 Main Street',
        city: 'Cairo',
        country: 'Egypt',
      );

      await auth.login(
        const LoginDto(email: 'ada@example.com', password: 'pass'),
      );
      expect(
        ApiClient.dio.options.headers['Authorization'],
        'Bearer test-token',
      );
      await auth.register(
        const RegisterDto(
          displayName: 'Ada',
          email: 'ada@example.com',
          phoneNumber: '123456789',
          password: 'pass',
        ),
      );
      await account.getAccount();
      await account.getAddress();
      await account.updateAddress(address);
      expect(await account.emailExists('ada@example.com'), isTrue);
      await basket.getBasket();
      expect(CartService.basketUpdates.value?.items.single.id, 7);
      await basket.updateItemQuantity(productId: 7, quantity: 3);
      await basket.addItem(productId: 7, quantity: 1);
      final products = await home.getProductsPagination(
        pageSize: 10,
        pageIndex: 2,
        search: 'cake',
        sort: 'name',
        brandId: 4,
        categoryId: 5,
      );
      expect(products.data, hasLength(1));
      await productDetails.getProductDetails('7');
      await explore.getCategories();
      await explore.getBrands();
      await explore.getFilteredProducts(
        categoryId: 5,
        brandId: 4,
        search: 'cake',
        sort: 'PriceAsc',
      );
      await orders.getOrders();
      await orders.getOrder(12);
      await orders.getDeliveryMethods();
      await orders.createOrder(
        const OrderRequest(deliverMethodId: 2, shippingAddress: address),
      );

      expect(
        adapter.requests
            .map((request) => '${request.method} ${request.uri.path}')
            .toList(),
        [
          'POST /api/Account/Login',
          'POST /api/Account/Register',
          'GET /api/Account',
          'GET /api/Account/Address',
          'PUT /api/Account/Address',
          'GET /api/Account/emailExisits',
          'GET /api/Basket',
          'POST /api/Basket',
          'POST /api/Basket',
          'GET /api/Products',
          'GET /api/Products/7',
          'GET /api/Products/categories',
          'GET /api/Products/brands',
          'GET /api/Products',
          'GET /api/Orders',
          'GET /api/Orders/12',
          'GET /api/Orders/DeliverMethods',
          'POST /api/Orders',
        ],
      );
      expect(adapter.requests[5].queryParameters, {'email': 'ada@example.com'});
      expect(adapter.requests[9].queryParameters, {
        'PageSize': 10,
        'PageIndex': 2,
        'Search': 'cake',
        'sort': 'name',
        'brandId': 4,
        'categoryId': 5,
      });
      expect(adapter.requests[13].queryParameters, {
        'categoryId': 5,
        'brandId': 4,
        'Search': 'cake',
        'sort': 'PriceAsc',
      });
      expect(jsonDecode(adapter.requestBodies[0]), {
        'email': 'ada@example.com',
        'password': 'pass',
      });
      expect(jsonDecode(adapter.requestBodies[1]), {
        'displayName': 'Ada',
        'email': 'ada@example.com',
        'phoneNumber': '123456789',
        'password': 'pass',
      });
      expect(jsonDecode(adapter.requestBodies[4]), address.toJson());
      expect(jsonDecode(adapter.requestBodies[7]), {
        'productId': 7,
        'quantity': 3,
      });
      expect(jsonDecode(adapter.requestBodies[17]), {
        'deliverMethodID': 2,
        'shippingAddress': address.toJson(),
      });
      expect(jsonDecode(adapter.requestBodies[8]), {
        'productId': 7,
        'quantity': 4,
      });
      expect(
        adapter.requests.every(
          (request) => request.uri.origin == 'https://talabat639.runasp.net',
        ),
        isTrue,
      );

      ApiClient.setAccessToken('test-token');
      expect(
        ApiClient.dio.options.headers['Authorization'],
        'Bearer test-token',
      );
      ApiClient.setAccessToken('Bearer test-token');
      expect(
        ApiClient.dio.options.headers['Authorization'],
        'Bearer test-token',
      );
      ApiClient.setAccessToken(null);
      expect(
        ApiClient.dio.options.headers.containsKey('Authorization'),
        isFalse,
      );
      dio.close();
    },
  );
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

class _ApiAdapter implements HttpClientAdapter {
  _ApiAdapter({this.productsAsPageList = false});

  final bool productsAsPageList;
  final requests = <RequestOptions>[];
  final requestBodies = <String>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (requestStream == null) {
      requestBodies.add('');
    } else {
      final bytes = await requestStream.fold<List<int>>(
        [],
        (buffer, chunk) => buffer..addAll(chunk),
      );
      requestBodies.add(utf8.decode(bytes));
    }

    return ResponseBody.fromString(
      jsonEncode(_response(options)),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  dynamic _response(RequestOptions request) {
    if (request.path == '/api/Account/emailExisits') return true;
    if (request.path == '/api/Account' ||
        request.path == '/api/Account/Login' ||
        request.path == '/api/Account/Register') {
      return {
        'displayName': 'Ada',
        'email': 'ada@example.com',
        'token': 'test-token',
      };
    }
    if (request.path == '/api/Account/Address') {
      return {
        'firstName': 'Ada',
        'lastName': 'Lovelace',
        'street': '1 Main Street',
        'city': 'Cairo',
        'country': 'Egypt',
      };
    }
    if (request.path == '/api/Basket') {
      return {
        'id': 'basket',
        'items': [
          {
            'id': 7,
            'productName': 'Cake',
            'price': 8.5,
            'pictureUrl': null,
            'category': 'Dessert',
            'brand': 'Bakery',
            'quantity': 3,
          },
        ],
      };
    }
    if (request.path == '/api/Products') {
      final page = {
        'page_Index': 2,
        'page_Size': 10,
        'count': 1,
        'data': [_product],
      };
      return productsAsPageList ? [page] : page;
    }
    if (request.path == '/api/Products/7') return _product;
    if (request.path == '/api/Products/categories') {
      return [
        {'id': 5, 'name': 'Dessert', 'pictureUrl': null},
      ];
    }
    if (request.path == '/api/Products/brands') {
      return [
        {'id': 4, 'name': 'Bakery'},
      ];
    }
    if (request.path == '/api/Orders/DeliverMethods') {
      return [
        {
          'id': 2,
          'shortName': 'Standard',
          'description': 'Standard delivery',
          'cost': 5.0,
          'deliveryTime': '2 days',
        },
      ];
    }
    if (request.path == '/api/Orders' || request.path == '/api/Orders/12') {
      return request.method == 'GET' && request.path == '/api/Orders'
          ? [_order]
          : _order;
    }
    throw StateError(
      'Unexpected API request: ${request.method} ${request.path}',
    );
  }

  Map<String, dynamic> get _product => {
    'id': 7,
    'name': 'Cake',
    'description': 'Chocolate cake',
    'pictureUrl': null,
    'price': 8.5,
    'brandId': 4,
    'brand': 'Bakery',
    'categoryId': 5,
    'category': 'Dessert',
  };

  Map<String, dynamic> get _order => {
    'id': 12,
    'buyerEmail': 'ada@example.com',
    'shippingAddress': {
      'firstName': 'Ada',
      'lastName': 'Lovelace',
      'street': '1 Main Street',
      'city': 'Cairo',
      'country': 'Egypt',
    },
    'status': 'Processing',
    'orderDate': '2026-10-28T10:00:00Z',
    'items': [
      {
        'id': 1,
        'productId': 7,
        'productName': 'Cake',
        'pictureUrl': null,
        'quantity': 3,
        'price': 8.5,
      },
    ],
    'deliveryMethod': 'Standard',
    'deliveryCost': 5.0,
    'subTotal': 25.5,
    'total': 30.5,
    'paymentIntentId': null,
  };

  @override
  void close({bool force = false}) {}
}
