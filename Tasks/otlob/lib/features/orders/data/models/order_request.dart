import 'package:otlob/features/account/data/models/address_dto.dart';

class OrderRequest {
  final int deliverMethodId;
  final AddressDto? shippingAddress;

  const OrderRequest({required this.deliverMethodId, this.shippingAddress});

  Map<String, dynamic> toJson() => {
    'deliverMethodID': deliverMethodId,
    if (shippingAddress != null) 'shippingAddress': shippingAddress!.toJson(),
  };
}
