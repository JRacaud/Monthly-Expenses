import 'package:monthly_expenses/features/report/models/transaction.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

@JsonSerializable()
class Report {
  Report(this.year, this.month);

  Report.empty() {
    this.year = 0;
    this.month = 0;
  }

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

  double currentAmount = 0;
  double estimatedEndOfMonth = 0;
  List<Transaction> extraExpenses = <Transaction>[];
  List<Transaction> extraIncomes = <Transaction>[];
  List<Transaction> fixedExpenses = <Transaction>[];
  List<Transaction> fixedIncomes = <Transaction>[];
  late int month;
  double startOfMonth = 0;
  late int year;

  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
