import 'package:finance/features/report/helpers/report_helper.dart';
import 'package:finance/features/report/helpers/transaction_helper.dart';
import 'package:finance/features/report/models/report.dart';
import 'package:finance/features/report/models/transaction.dart';
import 'package:finance/features/report/ui/components/report_totals.dart';
import 'package:finance/features/report/ui/components/report_transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportWidget extends StatefulWidget {
  final Report report;

  ReportWidget({required this.report});

  @override
  State<StatefulWidget> createState() => _ReportWidgetState(report);

  // void selectTransactionType(TransactionType type) =>
  //     state.selectTransactionType(type);

  // void setReport(Report report) => state.setReport(report);

  // void addTransaction(Transaction transaction) =>
  //     state.addTransaction(transaction);
}

class _ReportWidgetState extends State<ReportWidget> {
  _ReportWidgetState(this.report) {
    _updateTransactionList();
  }

  late Report report;

  late List<Transaction> _activeList;
  int _selectedTransactionOccurence = 0;
  TransactionOccurence _transactionOccurence = TransactionOccurence.Repeating;
  TransactionType _transactionType = TransactionType.Expenses;

  void setReport(Report report) {
    setState(() {
      this.report = report;
      _updateTransactionList();
    });
  }

  void addTransaction(Transaction transaction) {
    setState(() {
      _activeList.add(transaction);

      // Needed so the totals from the ReportTotals can be updated as well
      // If we tried to update it during building of the ListView in ReportTransactionList
      // it would not work and the app won't build.
      _updateTotals();
    });
  }

  void removeTransaction(Transaction transaction, List<Transaction> list) {
    setState(() {
      list.remove(transaction);
    });
  }

  void toggleIsProcessed(Transaction transaction) {
    setState(() {
      transaction.isProcessed = !transaction.isProcessed;
    });
  }

  selectTransactionType(TransactionType type) {
    _transactionType = type;

    setState(() {
      _updateTransactionList();
    });
  }

  selectTransactionOccurence(TransactionOccurence occurence) {
    _transactionOccurence = occurence;

    setState(() {
      _updateTransactionList();
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

  void _updateTransactionList() {
    _activeList = _getActiveList();
  }

  void _updateTotals() {
    _updateCurrentAmount();
    _updateEstimatedEndOfMonth();
  }

  void _updateCurrentAmount() {
    var totalFixedExpenses =
        TransactionHelper.getTotalProcessed(report.fixedExpenses);
    var totalFixedIncomes =
        TransactionHelper.getTotalProcessed(report.fixedIncomes);
    var totalExtraExpenses =
        TransactionHelper.getTotalProcessed(report.extraExpenses);
    var totalExtraIncomes =
        TransactionHelper.getTotalProcessed(report.extraIncomes);

    report.currentAmount =
        (report.startOfMonth + totalExtraIncomes + totalFixedIncomes) -
            (totalExtraExpenses + totalFixedExpenses);
  }

  void _updateEstimatedEndOfMonth() {
    var totalExpenses = ReportHelper.getTotalExpenses(report);
    var totalIncomes = ReportHelper.getTotalIncomes(report);

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
          ReportTotals(
            report: report,
            onStartAmountChanged: (val) {
              setState(() {
                report.startOfMonth = val;
                _updateTotals();
              });
            },
          ),
          Divider(thickness: 1),
          Expanded(
              child: ReportTransactionList(
                  list: _activeList,
                  onListChanged: () {
                    setState(() {
                      _updateTotals();
                    });
                  })),
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
