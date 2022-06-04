import 'package:intl/intl.dart';
import 'package:monthly_expenses/config/app_constants.dart';

extension DateTimeExtensions on DateTime {
  bool isSameYearMonth(DateTime date) {
    return ((year == date.year) && (month == date.month));
  }

  String yearMonth() {
    var formatter = DateFormat(reportDateFormatSpaced);

    return formatter.format(this);
  }
}