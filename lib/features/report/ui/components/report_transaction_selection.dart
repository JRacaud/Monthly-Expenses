import 'package:finance/features/report/models/transaction.dart';
import 'package:flutter/material.dart';

class ReportTransactionSelection extends StatefulWidget {
  const ReportTransactionSelection({
    Key? key,
    required this.onTransactionTypeSelected,
    required this.onTransactionOccurenceSelected,
  }) : super(key: key);

  final ValueChanged<TransactionType> onTransactionTypeSelected;
  final ValueChanged<TransactionOccurence> onTransactionOccurenceSelected;

  @override
  _ReportTransactionSelectionState createState() =>
      _ReportTransactionSelectionState();
}

class _ReportTransactionSelectionState
    extends State<ReportTransactionSelection> {
  var _typeIndex = 0;
  var _occurrenceIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        padding: EdgeInsets.only(left: 100, right: 100),
        child: BottomNavigationBar(
            elevation: 5,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.repeat), label: "Fixed"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.repeat_one), label: "Extra")
            ],
            currentIndex: _occurrenceIndex,
            onTap: (index) {
              setState(() {
                _occurrenceIndex = index;
              });
            }),
      ),
      BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.outbond), label: "Expenses"),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: "Incomes")
        ],
        currentIndex: _typeIndex,
        onTap: (index) {
          setState(() {
            _typeIndex = index;
          });
        },
      )
    ]);
  }
}
