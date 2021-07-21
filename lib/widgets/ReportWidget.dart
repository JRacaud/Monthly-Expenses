import 'package:finance/models/Report.dart';
import 'package:finance/models/Transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipe/swipe.dart';

enum TransactionList {
  FixedExpenses,
  FixedIncomes,
  ExtraExpenses,
  ExtraIncomes
}

class ReportWidget extends StatefulWidget {
  late final _ReportWidgetState state;

  ReportWidget(Report report) {
    state = _ReportWidgetState(report);
  }

  @override
  State<StatefulWidget> createState() => state;

  void setReport(Report report) {
    state.setReport(report);
  }

  void addItem() {
    state.addItem();
  }
}

class _ReportWidgetState extends State {
  TransactionList _transactionList = TransactionList.FixedExpenses;
  double _totalProcessed = 0;
  double _totalRemaining = 0;
  late Report report;
  late List<Transaction> _activeList;
  late List<Widget> _transactionWidgets = <Widget>[];

  _ReportWidgetState(this.report) {
    _activeList = _getActiveList();
    _totalProcessed = _getTotalProcessed();
    _totalRemaining = _getTotalRemainder();
    _transactionWidgets = _getTransactionWidgets();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
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
          ))
        ],
      ),
    );
  }

  void setReport(Report report) {
    setState(() {
      this.report = report;
      _activeList = _getActiveList();
      _totalProcessed = _getTotalProcessed();
      _totalRemaining = _getTotalRemainder();
      _transactionWidgets = _getTransactionWidgets();
    });
  }

  void addItem() {
    setState(() {
      _activeList.add(Transaction("Netflix", 12));
      _totalProcessed = _getTotalProcessed();
      _totalRemaining = _getTotalRemainder();
      _transactionWidgets = _getTransactionWidgets();
    });
  }

  TransactionList getPreviousTransactionType() {
    var transactionLists = TransactionList.values;
    var idx = _transactionList.index - 1;

    if (idx < 0) {
      return transactionLists.last;
    } else {
      return transactionLists[idx];
    }
  }

  TransactionList getNextTransactionType() {
    var transactionLists = TransactionList.values;
    var idx = _transactionList.index + 1;

    if (idx > transactionLists.length) {
      return transactionLists.first;
    } else {
      return transactionLists[idx];
    }
  }

  List<Transaction> _getActiveList() {
    switch (_transactionList) {
      case TransactionList.FixedExpenses:
        return report.fixedExpenses;
      case TransactionList.FixedIncomes:
        return report.fixedIncomes;
      case TransactionList.ExtraExpenses:
        return report.extraExpenses;
      case TransactionList.ExtraIncomes:
        return report.extraIncomes;
    }
  }

  double _getTotalProcessed() {
    var sum = 0.0;

    _activeList.forEach((element) {
      if (element.isProcessed) sum += element.price;
    });

    return sum;
  }

  double _getTotalRemainder() {
    var sum = 0.0;

    _activeList.forEach((element) {
      if (!element.isProcessed) sum += element.price;
    });

    return sum;
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

  void removeTransaction(Transaction transaction, List<Transaction> list) {
    list.remove(transaction);

    setState(() {
      _totalProcessed = _getTotalProcessed();
      _totalRemaining = _getTotalRemainder();
      _transactionWidgets = _getTransactionWidgets();
    });
  }

  void toggleIsProcessed(Transaction transaction) {
    transaction.isProcessed = !transaction.isProcessed;

    setState(() {
      _totalProcessed = _getTotalProcessed();
      _totalRemaining = _getTotalRemainder();
      _transactionWidgets = _getTransactionWidgets();
    });
  }
}
