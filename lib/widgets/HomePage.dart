import 'package:finance/models/Report.dart';
import 'package:finance/services/LocalReportService.dart';
import 'package:finance/services/IReportService.dart';
import 'package:finance/widgets/ReportWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    var state = _HomePageState();
    state.init(null);

    return state;
  }
}

class _HomePageState extends State {
  DateTime _currentDate = DateTime.now();
  IReportService _reportService = LocalReportService();
  late Report _currentReport;

  void init(Report? report) {
    if (report == null) {
      _reportService
          .getReport(_currentDate)
          .then((value) => _currentReport = value);
    } else {
      _currentReport = report;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: ReportWidget(_currentReport),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.outbond), label: "Expenses"),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: "Incomes")
        ],
      ),
    );
  }

  PreferredSizeWidget _getAppBar() {
    var reportDateTime = DateTime(_currentReport.year, _currentReport.month);

    Widget? leading =
        _currentDate.isAfter(reportDateTime) ? null : _getLeadingWidget();

    return AppBar(
      leading: leading,
      title: Text(_getReportName(reportDateTime)),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.arrow_right),
          onPressed: () => {
            setState(() async => {
                  _currentReport =
                      await _reportService.getPreviousReport(_currentReport)
                })
          },
        )
      ],
    );
  }

  Widget _getLeadingWidget() {
    return IconButton(
      icon: Icon(Icons.arrow_left),
      onPressed: getNextReport,
    );
  }

  void getNextReport() {
    DateTime reportDateTime =
        DateTime(_currentReport.year, _currentReport.month);

    if (_currentDate.isAfter(reportDateTime)) return;

    setState(() async =>
        {_currentReport = await _reportService.getNextReport(_currentReport)});
  }
}

String _getReportName(DateTime date) {
  var formatter = DateFormat(DateFormat.YEAR_MONTH);
  return formatter.format(date);
}
