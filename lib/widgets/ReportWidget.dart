import 'package:finance/models/Report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportWidget extends StatefulWidget {
  late final _ReportWidgetState state;

  ReportWidget(Report report) {
    state = _ReportWidgetState();
    state.report = report;
  }

  @override
  State<StatefulWidget> createState() => state;
}

class _ReportWidgetState extends State {
  late Report report;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
    ]);
  }
}
