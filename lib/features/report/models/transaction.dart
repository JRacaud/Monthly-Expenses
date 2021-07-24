import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

enum TransactionType { Expenses, Incomes }
enum TransactionOccurence { Repeating, Unique }

@JsonSerializable()
class Transaction {
  Transaction(this.name, this.price);

  Transaction.empty() {
    name = '';
    price = 0;
  }

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  DateTime date = DateTime.now();
  bool isProcessed = false;
  late String name;
  double price = 0;

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
