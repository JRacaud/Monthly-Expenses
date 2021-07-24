import 'package:finance/extensions/dart_time_extensions.dart';
import 'package:finance/features/report/helpers/report_helper.dart';
import 'package:finance/features/report/models/report.dart';
import 'package:finance/features/report/models/transaction.dart';
import 'package:finance/features/report/services/local_report_service.dart';
import 'package:finance/features/report/services/report_service.dart';
import 'package:finance/features/report/ui/components/report_widget.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  ReportPage(this.report);

  late final Report report;

  @override
  State<StatefulWidget> createState() => _ReportPageState(report);
}

class _ReportPageState extends State {
  _ReportPageState(this._currentReport) {
    _currentDate = DateTime.now();
    _reportDateTime = ReportHelper.getDateTime(_currentReport);
    _appBar = _getAppBar();
    _reportWidget = ReportWidget(_currentReport);
  }

  late PreferredSizeWidget _appBar;
  late DateTime _currentDate;
  late Report _currentReport;
  final _formKey = GlobalKey<FormState>();
  late DateTime _reportDateTime;
  ReportService _reportService = LocalReportService();
  late ReportWidget _reportWidget;
  int _selectedTransactionTypeIndex = 0;
  late Transaction _transaction = Transaction("", 0);
  bool _transactionProcessed = false;

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
        currentIndex: _selectedTransactionTypeIndex,
        onTap: (index) {
          setState(() {
            _selectedTransactionTypeIndex = index;
          });
          _reportWidget.selectTransactionType(TransactionType.values[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Name:"),
                                    TextFormField(
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Transaction name required";
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _transaction.name = value!;
                                        })
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Price:"),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            (num.tryParse(value) == null)) {
                                          return "Transaction price required";
                                        }
                                        return null;
                                      },
                                      onSaved: (value) => _transaction.price =
                                          double.parse(value!),
                                    )
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.all(8),
                                child: Row(children: [
                                  Text("Is Processed:"),
                                  StatefulBuilder(builder: (ctx, setState) {
                                    return Checkbox(
                                        value: _transactionProcessed,
                                        onChanged: (value) {
                                          setState(() {
                                            _transactionProcessed = value!;
                                          });
                                        });
                                  })
                                ])),
                            Padding(
                                padding: EdgeInsets.all(8),
                                child: ElevatedButton(
                                    child: Text("Add Transaction"),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        _transaction.isProcessed =
                                            _transactionProcessed;
                                        _reportWidget
                                            .addTransaction(_transaction);

                                        // This is to make sure that we will add a new object instead of modifying an existing one.
                                        _transaction = Transaction("", 0);
                                        // _formKey.currentState!.reset();
                                        _reportService
                                            .saveReport(_currentReport);
                                      }
                                    }))
                          ])),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
