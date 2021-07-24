import 'package:finance/extensions/dart_time_extensions.dart';
import 'package:finance/features/report/helpers/report_helper.dart';
import 'package:finance/features/report/models/report.dart';
import 'package:finance/features/report/services/local_report_service.dart';
import 'package:finance/features/report/ui/components/report_add_transaction_form_dialog.dart';
import 'package:finance/features/report/ui/components/report_transaction_selection.dart';
import 'package:finance/features/report/ui/components/report_widget.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _currentDate = DateTime.now();
  final _reportService = LocalReportService();
  var _report = Report.empty();

  @override
  void initState() {
    super.initState();

    _reportService.getReport(_currentDate).then((value) {
      _report = value;
    });
  }

  Future<void> getNextReport() async {
    var nextReport = await _reportService.getNextReport(_report);

    setState(() {
      _report = nextReport;
    });
  }

  Future<void> getPreviousReport() async {
    var previousReport = await _reportService.getPreviousReport(_report);

    setState(() {
      _report = previousReport;
    });
  }

  bool isCurrentDate() =>
      (_report.year != 0) &&
      (_report.month != 0) &&
      ReportHelper.getDateTime(_report).isSameYearMonth(_currentDate);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: isCurrentDate()
                ? null
                : () {
                    getNextReport();
                  },
          ),
          title: Text(ReportHelper.getName(_report)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                getPreviousReport();
              },
            )
          ]),
      // body: ,
      body: ReportWidget(report: _report),
      bottomSheet: ReportTransactionSelection(
        onTransactionOccurenceSelected: (occurence) {},
        onTransactionTypeSelected: (type) {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return ReportAddTransactionFormDialog(
                onTransactionAdded: (transaction) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(milliseconds: 500),
                      content: Text("Transaction Added")));
                },
              );
            }),
        child: const Icon(Icons.add),
      ),
    );
  }
}
