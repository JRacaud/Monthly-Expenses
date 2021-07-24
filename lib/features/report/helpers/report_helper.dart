import 'package:finance/features/report/helpers/transaction_helper.dart';
import 'package:finance/features/report/models/report.dart';
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
}
