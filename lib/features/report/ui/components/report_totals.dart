import 'package:finance/features/report/helpers/report_helper.dart';
import 'package:finance/features/report/models/report.dart';
import 'package:flutter/material.dart';
import 'package:finance/extensions/double_extensions.dart';

class ReportTotals extends StatefulWidget {
  final Report report;
  final Function(double) onStartAmountChanged;

  const ReportTotals(
      {Key? key, required this.report, required this.onStartAmountChanged})
      : super(key: key);

  @override
  _ReportTotalsState createState() => _ReportTotalsState();
}

class _ReportTotalsState extends State<ReportTotals> {
  final _formKey = GlobalKey<FormState>();

  _updateStartOfMonth() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Amount at the start of the month:"),
                TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    setState(() {
                      widget.onStartAmountChanged(double.parse(value!));
                    });
                  },
                  validator: (value) {
                    var val = double.tryParse(value!);

                    if (value.isEmpty || (val == null) || val < 0)
                      return "Invalid amount";
                    else
                      return null;
                  },
                ),
                Divider(color: Colors.transparent, height: 18),
                ElevatedButton(
                    child: Text("Set amount"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Navigator.of(context).pop();
                      }
                    })
              ],
            ),
          ));
        });
  }

  void _updateCurrentAmount() {
    var totalExpenses = ReportHelper.getTotalProcessedExpenses(widget.report);
    var totalIncomes = ReportHelper.getTotalProcessedIncomes(widget.report);

    widget.report.currentAmount =
        (widget.report.startOfMonth + totalIncomes) - totalExpenses;
  }

  void _updateEstimatedEndOfMonth() {
    var totalExpenses = ReportHelper.getTotalExpenses(widget.report);
    var totalIncomes = ReportHelper.getTotalIncomes(widget.report);

    widget.report.estimatedEndOfMonth =
        (widget.report.startOfMonth + totalIncomes) - totalExpenses;
  }

  @override
  void didUpdateWidget(ReportTotals oldWidget) {
    super.didUpdateWidget(oldWidget);

    _updateCurrentAmount();
    _updateEstimatedEndOfMonth();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
            child: Column(children: [
          Text("Current", style: TextStyle(fontSize: 18)),
          Divider(color: Colors.transparent, height: 4),
          Text("${widget.report.currentAmount.toCurrency()}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
        ])),
        Row(
          children: [
            TextButton(
              child: Text("${widget.report.startOfMonth.toCurrency()}"),
              onPressed: _updateStartOfMonth,
            ),
            Spacer(),
            Padding(
                padding: EdgeInsets.only(right: 12),
                child:
                    Text("${widget.report.estimatedEndOfMonth.toCurrency()}"))
          ],
        )
      ],
    );
  }
}
