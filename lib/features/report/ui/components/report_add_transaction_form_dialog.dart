import 'package:finance/features/report/models/transaction.dart';
import 'package:finance/features/report/validators/transaction_validator.dart';
import 'package:flutter/material.dart';

class ReportAddTransactionFormDialog extends StatefulWidget {
  const ReportAddTransactionFormDialog(
      {Key? key, required this.onTransactionAdded})
      : super(key: key);

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
                  "Add transaction",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name:"),
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
                        Text("Price:"),
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
                    child: Row(children: [
                      Text("Is Processed:"),
                      StatefulBuilder(builder: (ctx, setState) {
                        return Checkbox(
                            value: _transaction.isProcessed,
                            onChanged: (value) {
                              setState(() {
                                _transaction.isProcessed = value!;
                              });
                            });
                      })
                    ])),
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                        child: ElevatedButton(
                            child: Text("Add Transaction"),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                widget.onTransactionAdded(_transaction);
                                _transaction = Transaction.empty();
                              }
                            })))
              ])),
    );
  }
}
