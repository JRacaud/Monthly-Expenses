import 'dart:convert';
import 'dart:io';
import 'package:finance/config/app_constants.dart';
import 'package:finance/features/report/models/report.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'report_service.dart';

class LocalReportService implements ReportService {
  @override
  Future<Report> getNextReport(Report currentReport) {
    var nextMonth = currentReport.month + 1;
    var nextYear = currentReport.year + 1;

    var year = (nextMonth > 12) ? nextYear : currentReport.year;
    var month = (nextMonth > 12) ? 1 : nextMonth;

    var date = DateTime(year, month);

    return getReport(date);
  }

  @override
  Future<Report> getPreviousReport(Report currentReport) {
    var year = ((currentReport.month - 1) == 0)
        ? (currentReport.year - 1)
        : currentReport.year;

    var month =
        ((currentReport.month - 1) == 0) ? 12 : (currentReport.month - 1);

    var date = DateTime(year, month);

    return getReport(date);
  }

  @override
  Future<Report> getReport(DateTime date) async {
    var file = await _getReportFile(date);

    if (!await file.exists() || await file.length() == 0) {
      return Report(date.year, date.month);
    } else {
      var json = jsonDecode(await file.readAsString());
      var report = Report.fromJson(json);
      return report;
    }
  }

  @override
  void saveReport(Report report) async {
    var file = await _getReportFile(DateTime(report.year, report.month));

    var json = report.toJson();
    file.writeAsString(jsonEncode(json));
  }

  Future<File> _getReportFile(DateTime date) async {
    var appDataDir = await getApplicationDocumentsDirectory();
    var formatter = DateFormat(reportDateFormat);
    var filename = "reports/${formatter.format(date)}_finance_report.json";

    return File("${appDataDir.path}/$filename");
  }
}
