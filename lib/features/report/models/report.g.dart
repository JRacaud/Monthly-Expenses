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
    ..startOfMonth = (json['startOfMonth'] as num).toDouble()
    ..estimatedEndOfMonth = (json['estimatedEndOfMonth'] as num).toDouble()
    ..currentAmount = (json['currentAmount'] as num).toDouble()
    ..fixedExpenses = (json['fixedExpenses'] as List<dynamic>)
        .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
        .toList()
    ..fixedIncomes = (json['fixedIncomes'] as List<dynamic>)
        .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
        .toList()
    ..extraExpenses = (json['extraExpenses'] as List<dynamic>)
        .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
        .toList()
    ..extraIncomes = (json['extraIncomes'] as List<dynamic>)
        .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'month': instance.month,
      'year': instance.year,
      'startOfMonth': instance.startOfMonth,
      'estimatedEndOfMonth': instance.estimatedEndOfMonth,
      'currentAmount': instance.currentAmount,
      'fixedExpenses': instance.fixedExpenses,
      'fixedIncomes': instance.fixedIncomes,
      'extraExpenses': instance.extraExpenses,
      'extraIncomes': instance.extraIncomes,
    };
