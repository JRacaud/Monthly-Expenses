import 'dart:convert';
import 'dart:io';
import 'package:finance/models/Report.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'IReportService.dart';

class LocalReportService extends IReportService {
  @override
  Future<Report> getReport(DateTime date) async {
    var file = await _getReportFile(date);

    if (!await file.exists() || await file.length() == 0) {
      return Report(date.year, date.month);
    } else {
      var json = jsonDecode(await file.readAsString());
      return Report.fromJson(json);
    }
  }

  @override
  void saveReport(Report report) async {
    var file = await _getReportFile(DateTime(report.year, report.month));

    if (!await file.exists()) {
      file = await file.create();
    }

    var json = report.toJson();
    file.writeAsString(jsonEncode(json));
  }

  @override
  Future<Report> getNextReport(Report currentReport) {
    var year = ((currentReport.month + 1) > 12)
        ? (currentReport.year + 1)
        : currentReport.year;

    var month =
        ((currentReport.month + 1) > 12) ? 0 : (currentReport.month + 1);

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

  Future<File> _getReportFile(DateTime date) async {
    var appData = await getApplicationDocumentsDirectory();
    var formatter = DateFormat(REPORT_DATE_FORMAT);
    var filename = "${formatter.format(date)}_finance_report.json";

    return File("$appData/$filename");
  }
}
