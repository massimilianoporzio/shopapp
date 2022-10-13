// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      id: json['id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      products: (json['products'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      orderDate: DateTime.parse(json['orderDate'] as String),
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['amount'] = instance.amount;
  val['products'] = instance.products.map((e) => e.toJson()).toList();
  val['orderDate'] = instance.orderDate.toIso8601String();
  return val;
}
