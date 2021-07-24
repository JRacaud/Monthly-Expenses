import 'package:finance/extensions/double_extensions.dart';
import 'package:finance/features/report/helpers/transaction_helper.dart';
import 'package:finance/features/report/models/transaction.dart';
import 'package:flutter/material.dart';

class ReportTransactionList extends StatefulWidget {
  final List<Transaction> list;
  final VoidCallback onListChanged;

  const ReportTransactionList({
    Key? key,
    required this.list,
    required this.onListChanged,
  }) : super(key: key);

  @override
  _ReportTransactionListState createState() =>
      _ReportTransactionListState(list);
}

class _ReportTransactionListState extends State<ReportTransactionList> {
  late List<Transaction> _list;
  double _totalProcessed = 0;
  double _totalRemaining = 0;

  _ReportTransactionListState(this._list);

  void _updateTotals() {
    _totalProcessed = TransactionHelper.getTotalProcessed(_list);
    _totalRemaining = TransactionHelper.getTotalRemainder(_list);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text("Processed: ${_totalProcessed.toCurrency()}"),
      Text("Remaining: ${_totalRemaining.toCurrency()}"),
      Expanded(
          child: _list.length > 0
              ? ListView.builder(
                  itemCount: _list.length,
                  itemBuilder: (_, index) {
                    var textStyle = TextStyle(
                        color: _list[index].isProcessed
                            ? Colors.white
                            : Colors.black);

                    return Card(
                        color: _list[index].isProcessed
                            ? Colors.red
                            : Colors.white,
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
                                _list[index].isProcessed =
                                    !_list[index].isProcessed;
                                _updateTotals();
                              });
                              widget.onListChanged();
                            },
                            onLongPress: () {
                              setState(() {
                                _list.removeAt(index);
                                _updateTotals();
                              });
                              widget.onListChanged();
                            }));
                  })
              : Center(child: Text("No transactions"))),
    ]);
  }
}
