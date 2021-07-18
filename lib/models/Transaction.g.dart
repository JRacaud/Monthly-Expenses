// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return Transaction(
    json['name'] as String,
    (json['price'] as num).toDouble(),
  )
    ..date = DateTime.parse(json['date'] as String)
    ..isProcessed = json['isProcessed'] as bool;
}

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'date': instance.date.toIso8601String(),
      'isProcessed': instance.isProcessed,
    };
