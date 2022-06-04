// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) {
  return Report(
    json['year'] as int,
    json['month'] as int,
  )
    ..currentAmount = (json['currentAmount'] as num).toDouble()
    ..estimatedEndOfMonth = (json['estimatedEndOfMonth'] as num).toDouble()
    ..extraExpenses = (json['extraExpenses'] as List<dynamic>)
        .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
        .toList()
    ..extraIncomes = (json['extraIncomes'] as List<dynamic>)
        .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
        .toList()
    ..fixedExpenses = (json['fixedExpenses'] as List<dynamic>)
        .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
        .toList()
    ..fixedIncomes = (json['fixedIncomes'] as List<dynamic>)
        .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
        .toList()
    ..startOfMonth = (json['startOfMonth'] as num).toDouble();
}

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'currentAmount': instance.currentAmount,
      'estimatedEndOfMonth': instance.estimatedEndOfMonth,
      'extraExpenses': instance.extraExpenses,
      'extraIncomes': instance.extraIncomes,
      'fixedExpenses': instance.fixedExpenses,
      'fixedIncomes': instance.fixedIncomes,
      'month': instance.month,
      'startOfMonth': instance.startOfMonth,
      'year': instance.year,
    };
