import 'package:finance/features/report/ui/pages/report_page.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Finance', home: ReportPage());
  }
}
