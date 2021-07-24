import 'package:finance/extensions/dart_time_extensions.dart';
import 'package:finance/features/report/helpers/report_helper.dart';
import 'package:finance/features/report/models/report.dart';
import 'package:finance/features/report/models/transaction.dart';
import 'package:finance/features/report/services/local_report_service.dart';
import 'package:finance/features/report/ui/components/report_widget.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _currentDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  var _report = Report.empty();
  final _reportService = LocalReportService();
  int _selectedTransactionTypeIndex = 0;
  Transaction _transaction = Transaction("", 0);
  bool _transactionProcessed = false;

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
      body: ReportWidget(report: _report),
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
          // _reportWidget.selectTransactionType(TransactionType.values[index]);
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
                                        // _reportWidget
                                        //     .addTransaction(_transaction);

                                        // This is to make sure that we will add a new object instead of modifying an existing one.
                                        _transaction = Transaction("", 0);
                                        // _formKey.currentState!.reset();
                                        // _reportService
                                        //     .saveReport(_currentReport);
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
