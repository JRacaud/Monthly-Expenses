import 'package:finance/extensions/double_extensions.dart';
import 'package:finance/features/report/helpers/transaction_helper.dart';
import 'package:finance/features/report/models/report.dart';
import 'package:finance/features/report/models/transaction.dart';
import 'package:finance/features/report/ui/components/report_totals.dart';
import 'package:finance/features/report/ui/components/report_transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  void _updateTransactionList() {
    _activeList = _getActiveList();
  }

  void _updateTotals() {
    _totalProcessed = TransactionHelper.getTotalProcessed(_activeList);
    _totalRemaining = TransactionHelper.getTotalRemainder(_activeList);

    // _updateCurrentAmount();
    // _updateEstimatedEndOfMonth();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReportTotals(report),
          Divider(thickness: 1),
          Text("Processed: ${_totalProcessed.toCurrency()}"),
          Text(
            "Remaining: ${_totalRemaining.toCurrency()}",
          ),
          Divider(color: Colors.transparent),
          Expanded(child: ReportTransactionList(_activeList)),
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
