import 'package:finance/features/report/models/report.dart';
import 'package:finance/features/report/models/transaction.dart';
import 'package:finance/features/report/services/local_report_service.dart';
import 'package:finance/features/report/services/report_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportWidget extends StatefulWidget {
  ReportWidget(Report report) {
    state = _ReportWidgetState(report);
  }

  late final _ReportWidgetState state;

  @override
  State<StatefulWidget> createState() => state;

  void selectTransactionType(TransactionType type) =>
      state.selectTransactionType(type);

  void setReport(Report report) => state.setReport(report);

  void addTransaction(Transaction transaction) =>
      state.addTransaction(transaction);
}

class _ReportWidgetState extends State {
  _ReportWidgetState(this.report) {
    _updateTransactionList();
    _updateTotals();
  }

  late Report report;

  late List<Transaction> _activeList;
  final _formKey = GlobalKey<FormState>();
  NumberFormat _numberFormatter =
      NumberFormat.currency(locale: "EUR", symbol: "€");

  ReportService _reportService = LocalReportService();
  int _selectedTransactionOccurence = 0;
  double _totalProcessed = 0;
  double _totalRemaining = 0;
  TransactionOccurence _transactionOccurence = TransactionOccurence.Repeating;
  TransactionType _transactionType = TransactionType.Expenses;

  void setReport(Report report) {
    setState(() {
      this.report = report;
      _updateTransactionList();
      _updateTotals();
    });
  }

  void addTransaction(Transaction transaction) {
    _activeList.add(transaction);
    setState(() {
      _updateTransactionList();
      _updateTotals();
    });
  }

  void removeTransaction(Transaction transaction, List<Transaction> list) {
    list.remove(transaction);

    setState(() {
      _updateTotals();
    });
  }

  void toggleIsProcessed(Transaction transaction) {
    transaction.isProcessed = !transaction.isProcessed;

    setState(() {
      _updateTotals();
    });
  }

  selectTransactionType(TransactionType type) {
    _transactionType = type;

    setState(() {
      _updateTransactionList();
      _updateTotals();
    });
  }

  selectTransactionOccurence(TransactionOccurence occurence) {
    _transactionOccurence = occurence;

    setState(() {
      _updateTransactionList();
      _updateTotals();
    });
  }

  List<Transaction> _getActiveList() {
    if (_transactionType == TransactionType.Expenses) {
      switch (_transactionOccurence) {
        case TransactionOccurence.Repeating:
          return report.fixedExpenses;
        case TransactionOccurence.Unique:
          return report.extraExpenses;
      }
    } else {
      switch (_transactionOccurence) {
        case TransactionOccurence.Repeating:
          return report.fixedIncomes;
        case TransactionOccurence.Unique:
          return report.extraIncomes;
      }
    }
  }

  double _getTotalProcessed(List<Transaction> list) {
    var sum = 0.0;

    list.forEach((element) {
      if (element.isProcessed) sum += element.price;
    });

    return sum;
  }

  double _getTotalRemainder(List<Transaction> list) {
    var sum = 0.0;

    list.forEach((element) {
      if (!element.isProcessed) sum += element.price;
    });

    return sum;
  }

  double _getTotalTransactions(List<Transaction> list) {
    var sum = 0.0;

    list.forEach((element) {
      sum += element.price;
    });

    return sum;
  }

  double _getTotalExpenses(Report report) {
    var totalFixed = _getTotalTransactions(report.fixedExpenses);
    var totalExtra = _getTotalTransactions(report.extraExpenses);

    return totalFixed + totalExtra;
  }

  double _getTotalIncomes(Report report) {
    var totalFixed = _getTotalTransactions(report.fixedIncomes);
    var totalExtra = _getTotalTransactions(report.extraIncomes);

    return totalFixed + totalExtra;
  }

  void _updateTransactionList() {
    _activeList = _getActiveList();
  }

  void _updateTotals() {
    _totalProcessed = _getTotalProcessed(_activeList);
    _totalRemaining = _getTotalRemainder(_activeList);

    _updateCurrentAmount();
    _updateEstimatedEndOfMonth();
  }

  void _updateCurrentAmount() {
    var totalFixedExpenses = _getTotalProcessed(report.fixedExpenses);
    var totalFixedIncomes = _getTotalProcessed(report.fixedIncomes);
    var totalExtraExpenses = _getTotalProcessed(report.extraExpenses);
    var totalExtraIncomes = _getTotalProcessed(report.extraIncomes);

    report.currentAmount =
        (report.startOfMonth + totalExtraIncomes + totalFixedIncomes) -
            (totalExtraExpenses + totalFixedExpenses);
  }

  void _updateEstimatedEndOfMonth() {
    var totalExpenses = _getTotalExpenses(report);
    var totalIncomes = _getTotalIncomes(report);

    report.estimatedEndOfMonth =
        (report.startOfMonth + totalIncomes) - (totalExpenses);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Column(children: [
            Text("Current", style: TextStyle(fontSize: 18)),
            Divider(color: Colors.transparent, height: 4),
            Text("${_numberFormatter.format(report.currentAmount)}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
          ])),
          Row(
            children: [
              TextButton(
                child: Text("${_numberFormatter.format(report.startOfMonth)}"),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            content: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Amount at the start of the month:"),
                              TextFormField(
                                onSaved: (value) {
                                  setState(() {
                                    report.startOfMonth = double.parse(value!);
                                    _updateCurrentAmount();
                                    _updateEstimatedEndOfMonth();
                                  });
                                },
                                validator: (value) {
                                  var val = double.tryParse(value!);

                                  if (value.isEmpty || (val == null) || val < 0)
                                    return "Invalid amount";
                                  else
                                    return null;
                                },
                              ),
                              Divider(color: Colors.transparent, height: 18),
                              ElevatedButton(
                                  child: Text("Set amount"),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();

                                      _reportService.saveReport(report);
                                      Navigator.of(context).pop();
                                    }
                                  })
                            ],
                          ),
                        ));
                      });
                },
              ),
              Spacer(),
              Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Text(
                      "${_numberFormatter.format(report.estimatedEndOfMonth)}"))
            ],
          ),
          Divider(thickness: 1),
          Text("Processed: ${_numberFormatter.format(_totalProcessed)}"),
          Text(
            "Remaining: ${_numberFormatter.format(_totalRemaining)}",
          ),
          Divider(color: Colors.transparent),
          Expanded(
              child: _activeList.length > 0
                  ? ListView.builder(
                      itemCount: _activeList.length,
                      itemBuilder: (_, index) {
                        var textStyle = TextStyle(
                            color: _activeList[index].isProcessed
                                ? Colors.white
                                : Colors.black);

                        return Card(
                            color: _activeList[index].isProcessed
                                ? Colors.red
                                : Colors.white,
                            child: ListTile(
                              title: Text(
                                "${_activeList[index].name}",
                                style: textStyle,
                              ),
                              trailing: Text(
                                "${_numberFormatter.format(_activeList[index].price)}",
                                style: textStyle,
                              ),
                              onTap: () {
                                setState(() {
                                  _activeList[index].isProcessed =
                                      !_activeList[index].isProcessed;
                                });
                              },
                              onLongPress: () {
                                setState(() {
                                  _activeList.removeAt(index);
                                  _updateTotals();
                                });
                              },
                            ));
                      })
                  : Center(child: Text("No transactions"))),
          BottomNavigationBar(
              elevation: 3,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.repeat), label: "Fixed"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.repeat_one), label: "Extra")
              ],
              currentIndex: _selectedTransactionOccurence,
              onTap: (index) {
                setState(() {
                  _selectedTransactionOccurence = index;
                });
                selectTransactionOccurence(TransactionOccurence.values[index]);
              })
        ],
      ),
    );
  }
}
