import 'package:finance/models/Report.dart';
import 'package:finance/widgets/ReportWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State {
  int currentMonth = DateTime.now().month;
  Report currentReport = Report();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () => {},
          ),
          title: Text(_getMonthName(DateTime.now())),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () => {},
            )
          ],
        ),
        body: ReportWidget());
  }
}

String _getMonthName(DateTime date) {
  var formatter = DateFormat(DateFormat.MONTH);
  return formatter.format(date);
}
