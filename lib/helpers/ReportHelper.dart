import 'package:finance/models/Report.dart';
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
}
