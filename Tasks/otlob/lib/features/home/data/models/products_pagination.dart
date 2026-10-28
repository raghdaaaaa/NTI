import 'package:otlob/features/home/data/models/product_model.dart';

class ProductsPagination {
  final int pageIndex;
  final int pageSize;
  final int count;
  final List<ProductModel> data;

  const ProductsPagination({
    required this.pageIndex,
    required this.pageSize,
    required this.count,
    required this.data,
  });

  factory ProductsPagination.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List? ?? [];
    return ProductsPagination(
      pageIndex: (json['page_Index'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_Size'] as num?)?.toInt() ?? 10,
      count: (json['count'] as num?)?.toInt() ?? 0,
      data: list
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'page_Index': pageIndex,
    'page_Size': pageSize,
    'count': count,
    'data': data.map((e) => e.toJson()).toList(),
  };
}
