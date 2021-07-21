import 'package:finance/models/Report.dart';
import 'package:finance/models/Transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportWidget extends StatefulWidget {
  late final _ReportWidgetState state;

  ReportWidget(Report report) {
    state = _ReportWidgetState(report);
  }

  @override
  State<StatefulWidget> createState() => state;

  void selectTransactionType(TransactionType type) =>
      state.selectTransactionType(type);

  void setReport(Report report) => state.setReport(report);

  void addItem() => state.addTransaction();
}

class _ReportWidgetState extends State {
  TransactionType _transactionType = TransactionType.Expenses;
  TransactionOccurence _transactionOccurence = TransactionOccurence.Repeating;
  double _totalProcessed = 0;
  double _totalRemaining = 0;
  int _selectedTransactionOccurence = 0;
  late Report report;
  late List<Transaction> _activeList;
  late List<Widget> _transactionWidgets = <Widget>[];

  _ReportWidgetState(this.report) {
    _updateTransactionList();
    _updateTotals();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text("${report.currentAmount}")),
          Row(
            children: [
              Text("${report.startOfMonth}"),
              Spacer(),
              Text("${report.estimatedEndOfMonth}")
            ],
          ),
          Divider(thickness: 1),
          Text("Processed: $_totalProcessed"),
          Text("Remaining: $_totalRemaining"),
          Expanded(
              child: ListView(
            children: _transactionWidgets,
          )),
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

  void setReport(Report report) {
    setState(() {
      this.report = report;
      _updateTransactionList();
      _updateTotals();
    });
  }

  void addTransaction() {
    _activeList.add(Transaction("Netflix", 12));
    setState(() {
      _updateTransactionList();
      _updateTotals();
    });
  }

  void removeTransaction(Transaction transaction, List<Transaction> list) {
    list.remove(transaction);

    setState(() {
      _transactionWidgets = _getTransactionWidgets();
      _updateTotals();
    });
  }

  void toggleIsProcessed(Transaction transaction) {
    transaction.isProcessed = !transaction.isProcessed;

    setState(() {
      _transactionWidgets = _getTransactionWidgets();
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

  List<Widget> _getTransactionWidgets() {
    var widgets = <Widget>[];

    for (var transaction in _activeList) {
      var textStyle = TextStyle(
          color: transaction.isProcessed ? Colors.white : Colors.black);

      widgets.add(ListTile(
          title: Text(
            "${transaction.name}",
            style: textStyle,
          ),
          trailing: Text(
            "${transaction.price}",
            style: textStyle,
          ),
          tileColor:
              transaction.isProcessed ? Colors.redAccent : Colors.transparent,
          onLongPress: () {
            removeTransaction(transaction, _activeList);
          },
          onTap: () {
            toggleIsProcessed(transaction);
          }));
    }

    return widgets;
  }

  void _updateTransactionList() {
    _activeList = _getActiveList();
    _transactionWidgets = _getTransactionWidgets();
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
}
