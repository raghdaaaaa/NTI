class DeliveryMethodModel {
  final int id;
  final String shortName;
  final String description;
  final double cost;
  final String deliveryTime;

  const DeliveryMethodModel({
    required this.id,
    required this.shortName,
    required this.description,
    required this.cost,
    required this.deliveryTime,
  });

  factory DeliveryMethodModel.fromJson(Map<String, dynamic> json) =>
      DeliveryMethodModel(
        id: _toInt(json['id']),
        shortName: json['shortName']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        cost: _toDouble(json['cost']),
        deliveryTime: json['deliveryTime']?.toString() ?? '',
      );
}

int _toInt(dynamic value) =>
    value is num ? value.toInt() : int.tryParse('$value') ?? 0;

double _toDouble(dynamic value) =>
    value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
