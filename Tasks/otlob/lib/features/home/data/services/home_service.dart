import 'package:dio/dio.dart';
import 'package:otlob/core/network/api_client.dart';
import 'package:otlob/features/home/data/models/product_model.dart';
import 'package:otlob/features/home/data/models/products_pagination.dart';

class HomeService {
  final Dio _dio;

  HomeService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  Future<ProductsPagination> getProductsPagination({
    int? pageSize,
    int? pageIndex,
    String? search,
    String? sort,
    int? brandId,
    int? categoryId,
  }) async {
    final queryParams = <String, dynamic>{};
    if (pageSize != null) queryParams['PageSize'] = pageSize;
    if (pageIndex != null) queryParams['PageIndex'] = pageIndex;
    if (search != null && search.isNotEmpty) queryParams['Search'] = search;
    if (sort != null && sort.isNotEmpty) queryParams['sort'] = sort;
    if (brandId != null) queryParams['brandId'] = brandId;
    if (categoryId != null) queryParams['categoryId'] = categoryId;

    try {
      final response = await _dio.get(
        '/api/Products',
        queryParameters: queryParams,
      );

      final dynamic data = response.data;
      if (data is Map<String, dynamic>) {
        return ProductsPagination.fromJson(data);
      } else if (data is Map) {
        return ProductsPagination.fromJson(Map<String, dynamic>.from(data));
      } else if (data is List) {
        final products = data
            .whereType<Map>()
            .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        return ProductsPagination(
          pageIndex: pageIndex ?? 1,
          pageSize: pageSize ?? products.length,
          count: products.length,
          data: products,
        );
      }
      return const ProductsPagination(
        pageIndex: 1,
        pageSize: 0,
        count: 0,
        data: [],
      );
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to load products');
    }
  }

  Future<List<ProductModel>> getProducts({
    int? pageSize,
    int? pageIndex,
    String? search,
    String? sort,
    int? brandId,
    int? categoryId,
  }) async {
    final pagination = await getProductsPagination(
      pageSize: pageSize,
      pageIndex: pageIndex,
      search: search,
      sort: sort,
      brandId: brandId,
      categoryId: categoryId,
    );
    return pagination.data;
  }
}
