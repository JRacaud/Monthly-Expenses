import 'package:finance/features/report/models/report.dart';

abstract class ReportService {
  Future<Report> getReport(DateTime date);
  void saveReport(Report report);

  Future<Report> getPreviousReport(Report currentReport);
  Future<Report> getNextReport(Report currentReport);
}
