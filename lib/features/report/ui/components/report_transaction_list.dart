import 'package:finance/extensions/double_extensions.dart';
import 'package:finance/features/report/models/transaction.dart';
import 'package:flutter/material.dart';

class ReportTransactionList extends StatefulWidget {
  final List<Transaction> _list;

  const ReportTransactionList(this._list, {Key? key}) : super(key: key);

  @override
  _ReportTransactionListState createState() =>
      _ReportTransactionListState(_list);
}

class _ReportTransactionListState extends State<ReportTransactionList> {
  final List<Transaction> _list;

  _ReportTransactionListState(this._list);

  @override
  Widget build(BuildContext context) {
    return _list.length > 0
        ? ListView.builder(
            itemCount: _list.length,
            itemBuilder: (_, index) {
              var textStyle = TextStyle(
                  color:
                      _list[index].isProcessed ? Colors.white : Colors.black);

              return Card(
                  color: _list[index].isProcessed ? Colors.red : Colors.white,
                  child: ListTile(
                    title: Text(
                      "${_list[index].name}",
                      style: textStyle,
                    ),
                    trailing: Text(
                      "${_list[index].price.toCurrency()}",
                      style: textStyle,
                    ),
                    onTap: () {
                      setState(() {
                        _list[index].isProcessed = !_list[index].isProcessed;
                      });
                    },
                    onLongPress: () {
                      setState(() {
                        _list.removeAt(index);
                        // _updateTotals();
                      });
                    },
                  ));
            })
        : Center(child: Text("No transactions"));
  }
}
