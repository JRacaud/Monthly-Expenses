import 'package:finance/models/Transaction.dart';

import 'package:json_annotation/json_annotation.dart';

part 'Report.g.dart';

@JsonSerializable()
class Report {
  late int month;
  late int year;

  Report(this.year, this.month);

  double startOfMonth = 0;
  double estimatedEndOfMonth = 0;
  double currentAmount = 0;
  List<Transaction> fixedExpenses = <Transaction>[];
  List<Transaction> fixedIncomes = <Transaction>[];
  List<Transaction> extraExpenses = <Transaction>[];
  List<Transaction> extraIncomes = <Transaction>[];

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
