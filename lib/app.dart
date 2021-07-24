import 'package:finance/features/report/models/report.dart';
import 'package:finance/features/report/ui/pages/report_page.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  late final Report report;

  App(this.report);

  @override
  State<StatefulWidget> createState() => _AppState(report);
}

class _AppState extends State {
  late Report report;

  _AppState(this.report);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Finance', home: ReportPage(report));
  }
}
