import 'package:finance/features/report/helpers/report_helper.dart';
import 'package:finance/features/report/helpers/transaction_helper.dart';
import 'package:finance/features/report/models/report.dart';
import 'package:finance/features/report/services/local_report_service.dart';
import 'package:flutter/material.dart';
import 'package:finance/extensions/double_extensions.dart';

class ReportTotals extends StatefulWidget {
  final Report report;

  const ReportTotals(this.report, {Key? key}) : super(key: key);

  @override
  _ReportTotalsState createState() => _ReportTotalsState(report);
}

class _ReportTotalsState extends State<ReportTotals> {
  final Report report;
  final _formKey = GlobalKey<FormState>();
  final _reportService = LocalReportService();

  _ReportTotalsState(this.report);

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
                  onSaved: (value) {
                    setState(() {
                      report.startOfMonth = double.parse(value!);
                      _updateCurrentAmount();
                      _updateEstimatedEndOfMonth();
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

                        _reportService.saveReport(report);
                        Navigator.of(context).pop();
                      }
                    })
              ],
            ),
          ));
        });
  }

  void _updateCurrentAmount() {
    var totalFixedExpenses =
        TransactionHelper.getTotalProcessed(report.fixedExpenses);
    var totalFixedIncomes =
        TransactionHelper.getTotalProcessed(report.fixedIncomes);
    var totalExtraExpenses =
        TransactionHelper.getTotalProcessed(report.extraExpenses);
    var totalExtraIncomes =
        TransactionHelper.getTotalProcessed(report.extraIncomes);

    report.currentAmount =
        (report.startOfMonth + totalExtraIncomes + totalFixedIncomes) -
            (totalExtraExpenses + totalFixedExpenses);
  }

  void _updateEstimatedEndOfMonth() {
    var totalExpenses = ReportHelper.getTotalExpenses(report);
    var totalIncomes = ReportHelper.getTotalIncomes(report);

    report.estimatedEndOfMonth =
        (report.startOfMonth + totalIncomes) - (totalExpenses);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
            child: Column(children: [
          Text("Current", style: TextStyle(fontSize: 18)),
          Divider(color: Colors.transparent, height: 4),
          Text("${report.currentAmount.toCurrency()}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
        ])),
        Row(
          children: [
            TextButton(
              child: Text("${report.startOfMonth.toCurrency()}"),
              onPressed: _updateStartOfMonth,
            ),
            Spacer(),
            Padding(
                padding: EdgeInsets.only(right: 12),
                child: Text("${report.estimatedEndOfMonth.toCurrency()}"))
          ],
        )
      ],
    );
  }
}
