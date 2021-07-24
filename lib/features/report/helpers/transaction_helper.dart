import 'package:finance/features/report/models/transaction.dart';

class TransactionHelper {
  static double getTotalProcessed(List<Transaction> list) {
    var sum = 0.0;

    list.forEach((element) {
      if (element.isProcessed) sum += element.price;
    });

    return sum;
  }

  static double getTotalRemainder(List<Transaction> list) {
    var sum = 0.0;

    list.forEach((element) {
      if (!element.isProcessed) sum += element.price;
    });

    return sum;
  }

  static double getTotalTransactions(List<Transaction> list) {
    var sum = 0.0;

    list.forEach((element) {
      sum += element.price;
    });

    return sum;
  }
}
