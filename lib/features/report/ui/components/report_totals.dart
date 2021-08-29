import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:monthly_expenses/app.dart';
import 'package:monthly_expenses/features/report/helpers/report_helper.dart';
import 'package:monthly_expenses/features/report/models/report.dart';
import 'package:monthly_expenses/extensions/double_extensions.dart';
import 'package:monthly_expenses/features/settings/settings_parameters.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                Text("${AppLocalizations.of(context)!.amountStartOfMonth}:"),
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
                      return AppLocalizations.of(context)!.invalidAmount;
                    else
                      return null;
                  },
                ),
                Divider(color: Colors.transparent, height: 18),
                ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.setAmount),
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

  String _getNumberAsCurrency(double number) {
    return number.toCurrency(
        App.preferences.getString(SettingsParameters.CurrencySymbol) ??
            SettingsParameters.DefaultCurrencySymbol);
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
          Text(AppLocalizations.of(context)!.current,
              style: TextStyle(fontSize: 18)),
          Divider(color: Colors.transparent, height: 4),
          Text(_getNumberAsCurrency(widget.report.currentAmount),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
        ])),
        Row(
          children: [
            Column(
              children: [
                Text("${AppLocalizations.of(context)!.startOfMonth}"),
                TextButton(
                  child: Text(_getNumberAsCurrency(widget.report.startOfMonth)),
                  onPressed: _updateStartOfMonth,
                ),
              ],
            ),
            Spacer(),
            Padding(
                padding: EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    Text("${AppLocalizations.of(context)!.endOfMonth}"),
                    Text(_getNumberAsCurrency(
                        widget.report.estimatedEndOfMonth)),
                  ],
                ))
          ],
        )
      ],
    );
  }
}
