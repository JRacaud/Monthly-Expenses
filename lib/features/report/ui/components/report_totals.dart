import 'package:finance/features/report/models/report.dart';
import 'package:finance/features/report/services/local_report_service.dart';
import 'package:flutter/material.dart';
import 'package:finance/extensions/double_extensions.dart';

class ReportTotals extends StatefulWidget {
  final Report report;
  final Function(double) onStartAmountChanged;

  const ReportTotals(
      {Key? key, required this.report, required this.onStartAmountChanged})
      : super(key: key);

  @override
  _ReportTotalsState createState() => _ReportTotalsState(report);
}

class _ReportTotalsState extends State<ReportTotals> {
  late Report report;
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

                        _reportService.saveReport(report);
                        Navigator.of(context).pop();
                      }
                    })
              ],
            ),
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    // _updateCurrentAmount();
    // _updateEstimatedEndOfMonth();

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
