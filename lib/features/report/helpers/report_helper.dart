import 'package:monthly_expenses/features/report/helpers/transaction_helper.dart';
import 'package:monthly_expenses/features/report/models/report.dart';
import 'package:monthly_expenses/features/report/models/transaction.dart';
import 'package:intl/intl.dart';

class ReportHelper {
  static String getName(Report report) {
    var date = getDateTime(report);
    var formatter = DateFormat(DateFormat.YEAR_MONTH);
    return formatter.format(date);
  }

  static DateTime getDateTime(Report report) {
    return DateTime(report.year, report.month);
  }

  static double getTotalExpenses(Report report) {
    var totalFixed =
        TransactionHelper.getTotalTransactions(report.fixedExpenses);
    var totalExtra =
        TransactionHelper.getTotalTransactions(report.extraExpenses);

    return totalFixed + totalExtra;
  }

  static double getTotalIncomes(Report report) {
    var totalFixed =
        TransactionHelper.getTotalTransactions(report.fixedIncomes);
    var totalExtra =
        TransactionHelper.getTotalTransactions(report.extraIncomes);

    return totalFixed + totalExtra;
  }

  static double getTotalProcessedExpenses(Report report) {
    var totalFixed = TransactionHelper.getTotalProcessed(report.fixedExpenses);
    var totalExtra =
        TransactionHelper.getTotalTransactions(report.extraExpenses);

    return totalFixed + totalExtra;
  }

  static double getTotalProcessedIncomes(Report report) {
    var totalFixed = TransactionHelper.getTotalProcessed(report.fixedIncomes);
    var totalExtra =
        TransactionHelper.getTotalTransactions(report.extraIncomes);

    return totalFixed + totalExtra;
  }

  static void addTransaction(Report report, Transaction transaction,
      TransactionType type, TransactionOccurence occurence) {
    var list = getList(report, type, occurence);

    list.add(transaction);
  }

  static List<Transaction> getList(
      Report report, TransactionType type, TransactionOccurence occurence) {
    if (type == TransactionType.Expenses) {
      switch (occurence) {
        case TransactionOccurence.Repeating:
          return report.fixedExpenses;
        case TransactionOccurence.Unique:
          return report.extraExpenses;
      }
    } else {
      switch (occurence) {
        case TransactionOccurence.Repeating:
          return report.fixedIncomes;
        case TransactionOccurence.Unique:
          return report.extraIncomes;
      }
    }
  }
}
