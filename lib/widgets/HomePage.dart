import 'package:finance/helpers/ReportHelper.dart';
import 'package:finance/models/Report.dart';
import 'package:finance/services/LocalReportService.dart';
import 'package:finance/services/IReportService.dart';
import 'package:finance/widgets/ReportWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:finance/extensions/DateTimeExtensions.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    var state = _HomePageState();
    state.init(null);

    return state;
  }
}

class _HomePageState extends State {
  IReportService _reportService = LocalReportService();
  late PreferredSizeWidget _appBar;
  late DateTime _currentDate;
  late Report _currentReport;
  late DateTime _reportDateTime;
  late ReportWidget _reportWidget;

  _HomePageState() {
    _currentDate = DateTime.now();
    _currentReport = Report(_currentDate.year, _currentDate.month);
    _reportDateTime = ReportHelper.getDateTime(_currentReport);
    _appBar = _getAppBar();
    _reportWidget = ReportWidget(_currentReport);
  }

  void init(Report? report) async {
    if (report == null) {
      _currentReport = await _reportService.getReport(_currentDate);
    } else {
      _currentReport = report;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _reportWidget,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.outbond), label: "Expenses"),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: "Incomes")
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _reportWidget.addItem();
          _reportService.saveReport(_currentReport);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  PreferredSizeWidget _getAppBar() {
    return AppBar(
      leading: _getLeadingWidget(_reportDateTime),
      title: Text(ReportHelper.getName(_currentReport)),
      centerTitle: true,
      actions: [
        IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () {
              _reportService.saveReport(_currentReport);
              getPreviousReport();
            })
      ],
    );
  }

  Widget? _getLeadingWidget(DateTime reportDateTime) {
    return reportDateTime.isSameYearMonth(_currentDate)
        ? null
        : IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              _reportService.saveReport(_currentReport);
              getNextReport();
            },
          );
  }

  Future<void> getNextReport() async {
    if (_reportDateTime.isSameYearMonth(_currentDate)) return;

    var report = await _reportService.getNextReport(_currentReport);
    _reportDateTime = ReportHelper.getDateTime(report);
    _currentReport = report;

    setState(() {
      _appBar = _getAppBar();
      _reportWidget.setReport(_currentReport);
    });
  }

  Future<void> getPreviousReport() async {
    var report = await _reportService.getPreviousReport(_currentReport);
    _reportDateTime = ReportHelper.getDateTime(report);
    _currentReport = report;

    setState(() {
      _appBar = _getAppBar();
      _reportWidget.setReport(_currentReport);
    });
  }
}
