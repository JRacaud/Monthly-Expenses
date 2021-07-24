import 'package:finance/config/app_constants.dart';
import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  bool isSameYearMonth(DateTime date) {
    return ((this.year == date.year) && (this.month == date.month));
  }

  String yearMonth() {
    var formatter = DateFormat(reportDateFormatSpaced);

    return formatter.format(this);
  }
}
