import 'package:finance/app.dart';
import 'package:finance/features/report/services/local_report_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var app = await initializeApplication();

  runApp(app);
}

Future<App> initializeApplication() async {
  var service = LocalReportService();
  var report = await service.getReport(DateTime.now());

  return App(report);
}
