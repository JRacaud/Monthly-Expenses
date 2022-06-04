import 'package:monthly_expenses/features/report/helpers/report_helper.dart';
import 'package:monthly_expenses/features/report/models/report.dart';
import 'package:monthly_expenses/features/report/models/transaction.dart';
import 'package:monthly_expenses/features/report/ui/components/report_totals.dart';
import 'package:monthly_expenses/features/report/ui/components/report_transaction_list.dart';
import 'package:flutter/material.dart';

class ReportWidget extends StatefulWidget {
  final Report report;
  final TransactionType type;
  final TransactionOccurence occurence;
  final ValueChanged onStartOfMonthChanged;
  final VoidCallback onTransactionsChanged;

  ReportWidget({
    required this.report,
    required this.type,
    required this.occurence,
    required this.onStartOfMonthChanged,
    required this.onTransactionsChanged,
  });

  @override
  State<StatefulWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  List<Transaction> _list = <Transaction>[];

  List<Transaction> _getTransactionList() {
    return ReportHelper.getList(widget.report, widget.type, widget.occurence);
  }

  @override
  void didUpdateWidget(ReportWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    _list = _getTransactionList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReportTotals(
              report: widget.report,
              onStartAmountChanged: (val) {
                widget.onStartOfMonthChanged(val);
              }),
          Divider(thickness: 1),
          Expanded(
              child: ReportTransactionList(
                  list: _list,
                  type: widget.type,
                  onTransactionsChanged: () {
                    setState(() {
                      widget.onTransactionsChanged();
                    });
                  })),
        ],
      ),
    );
  }
}
