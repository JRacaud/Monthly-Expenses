import 'package:finance/extensions/double_extensions.dart';
import 'package:finance/features/report/helpers/transaction_helper.dart';
import 'package:finance/features/report/models/transaction.dart';
import 'package:flutter/material.dart';

class ReportTransactionList extends StatefulWidget {
  final List<Transaction> list;
  final VoidCallback onTransactionsChanged;

  const ReportTransactionList({
    Key? key,
    required this.list,
    required this.onTransactionsChanged,
  }) : super(key: key);

  @override
  _ReportTransactionListState createState() => _ReportTransactionListState();
}

class _ReportTransactionListState extends State<ReportTransactionList> {
  double _totalProcessed = 0;
  double _totalRemaining = 0;

  void _updateTotals() {
    _totalProcessed = TransactionHelper.getTotalProcessed(widget.list);
    _totalRemaining = TransactionHelper.getTotalRemainder(widget.list);
  }

  @override
  void didUpdateWidget(ReportTransactionList oldWidget) {
    super.didUpdateWidget(oldWidget);

    _updateTotals();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text("Processed: ${_totalProcessed.toCurrency()}"),
      Text("Remaining: ${_totalRemaining.toCurrency()}"),
      Expanded(
          child: widget.list.length > 0
              ? ListView.builder(
                  itemCount: widget.list.length,
                  itemBuilder: (_, index) {
                    var textStyle = TextStyle(
                        color: widget.list[index].isProcessed
                            ? Colors.white
                            : Colors.black);

                    return Card(
                        color: widget.list[index].isProcessed
                            ? Colors.red
                            : Colors.white,
                        child: ListTile(
                            title: Text(
                              "${widget.list[index].name}",
                              style: textStyle,
                            ),
                            trailing: Text(
                              "${widget.list[index].price.toCurrency()}",
                              style: textStyle,
                            ),
                            onTap: () {
                              setState(() {
                                widget.list[index].isProcessed =
                                    !widget.list[index].isProcessed;
                                _updateTotals();
                              });
                              widget.onTransactionsChanged();
                            },
                            onLongPress: () {
                              setState(() {
                                widget.list.removeAt(index);
                                _updateTotals();
                              });
                              widget.onTransactionsChanged();
                            }));
                  })
              : Center(child: Text("No transactions"))),
    ]);
  }
}
