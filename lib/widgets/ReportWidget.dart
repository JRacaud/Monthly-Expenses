import 'package:finance/models/Report.dart';
import 'package:finance/models/Transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  late Report report;
  late List<Transaction> _activeList;

  _ReportWidgetState(Report report) {
    this.report = report;
    _activeList = getActiveList();
  }

  @override
  Widget build(BuildContext context) {
    return Swipe(
      child: Column(children: [
        Text(report.currentAmount.toString()),
        Row(
          children: [
            TextButton(
              child: Text("Start: ${report.startOfMonth}"),
              onPressed: () => {},
            ),
            Spacer(),
            Text("End (est.): ${report.estimatedEndOfMonth}"),
          ],
        ),
        Divider(
          thickness: 1,
        ),
        Text(_activeList.toString()),
      ]),
      onSwipeLeft: () {
        _transactionList = getPreviousTransactionType();
        setState(() {
          _activeList = getActiveList();
        });
      },
      onSwipeRight: () {
        _transactionList = getNextTransactionType();
        setState(() {
          _activeList = getActiveList();
        });
      },
    );
  }

  void setReport(Report report) {
    setState(() {
      this.report = report;
      _activeList = getActiveList();
    });
  }

  void addItem() {
    setState(() {
      _activeList.add(Transaction("Netflix", 12));
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

  List<Transaction> getActiveList() {
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
}
