import 'package:finance/models/Transaction.dart';

class Report {
  late int month;
  late int year;

  int startOfMonth = 0;
  int estimatedEndOfMonth = 0;
  int currentAmount = 0;
  List<Transaction> fixedExpenses = <Transaction>[];
  List<Transaction> fixedIncomes = <Transaction>[];
  List<Transaction> extraExpenses = <Transaction>[];
  List<Transaction> extraIncomes = <Transaction>[];
}
