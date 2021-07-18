import 'package:json_annotation/json_annotation.dart';

part 'Transaction.g.dart';

@JsonSerializable()
class Transaction {
  late String name;
  double price = 0;
  DateTime date = DateTime.now();
  bool isProcessed = false;

  Transaction(this.name, this.price);

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
