import 'package:monthly_expenses/features/report/models/transaction.dart';
import 'package:monthly_expenses/features/report/validators/transaction_validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ReportAddTransactionFormDialog extends StatefulWidget {
  const ReportAddTransactionFormDialog(
      {Key? key, required this.onTransactionAdded, required this.occurence})
      : super(key: key);

  final TransactionOccurence occurence;
  final ValueChanged<Transaction> onTransactionAdded;

  @override
  _ReportAddTransactionFormDialogState createState() =>
      _ReportAddTransactionFormDialogState();
}

class _ReportAddTransactionFormDialogState
    extends State<ReportAddTransactionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  Transaction _transaction = Transaction.empty();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
          key: _formKey,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text(
                  AppLocalizations.of(context)!.addTransaction,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${AppLocalizations.of(context)!.name}:"),
                        TextFormField(
                            keyboardType: TextInputType.text,
                            validator: TransactionValidator.validateName,
                            onSaved: (value) {
                              _transaction.name = value!;
                            })
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${AppLocalizations.of(context)!.price}"),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          validator: TransactionValidator.validatePrice,
                          onSaved: (value) =>
                              _transaction.price = double.parse(value!),
                        )
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.all(8),
                    child: widget.occurence == TransactionOccurence.Repeating
                        ? Row(children: [
                            Text("${AppLocalizations.of(context)!.processed}:"),
                            StatefulBuilder(builder: (ctx, setState) {
                              return Checkbox(
                                  value: _transaction.isProcessed,
                                  onChanged: (value) {
                                    setState(() {
                                      _transaction.isProcessed = value!;
                                    });
                                  });
                            })
                          ])
                        : null),
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                        child: ElevatedButton(
                            child: Text(
                                "${AppLocalizations.of(context)!.addTransaction}"),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                var isProcessed = _transaction.isProcessed;

                                if (widget.occurence ==
                                    TransactionOccurence.Unique)
                                  _transaction.isProcessed = true;

                                widget.onTransactionAdded(_transaction);
                                _transaction = Transaction.empty();
                                _transaction.isProcessed = isProcessed;
                              }
                            })))
              ])),
    );
  }
}
