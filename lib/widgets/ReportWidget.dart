import 'package:finance/models/Report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State {
  Report report = Report();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(report.currentAmount.toString()),
      Row(
        children: [
          TextButton(
              onPressed: () => {
                    setState(() => {report.startOfMonth += 100})
                  },
              child: Text("Start: ${report.startOfMonth}")),
          Spacer(),
          TextButton(
              onPressed: () => {
                    setState(() => {report.estimatedEndOfMonth += 100})
                  },
              child: Text("End (est.): ${report.estimatedEndOfMonth}")),
        ],
      ),
    ]);
  }
}

String _getDateString(Report report) {
  var dateTime = DateTime(report.year, report.month);
  var formatter = DateFormat(DateFormat.YEAR_MONTH);

  return formatter.format(dateTime);
}
