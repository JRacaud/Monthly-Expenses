import 'package:finance/models/Report.dart';

const String REPORT_DATE_FORMAT = 'yyyy-MM';

abstract class IReportService {
  Future<Report> getReport(DateTime date);
  void saveReport(Report report);

  Future<Report> getPreviousReport(Report currentReport);
  Future<Report> getNextReport(Report currentReport);
}
