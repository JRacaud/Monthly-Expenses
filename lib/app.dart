import 'package:finance/features/report/models/report.dart';
import 'package:finance/features/report/ui/pages/report_page.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  App(this.report);

  late final Report report;

  @override
  State<StatefulWidget> createState() => _AppState(report);
}

class _AppState extends State {
  _AppState(this.report);

  late Report report;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Finance', home: ReportPage(report));
  }
}
