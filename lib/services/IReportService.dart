import 'package:finance/models/Report.dart';

const REPORT_DATE_FORMAT = "YYYYMMMM";

abstract class IReportService {
  Future<Report> getReport(DateTime date);
  void saveReport(Report report);

  Future<Report> getPreviousReport(Report currentReport);
  Future<Report> getNextReport(Report currentReport);
}
