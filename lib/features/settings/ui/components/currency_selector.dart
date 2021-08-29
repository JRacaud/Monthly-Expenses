import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:monthly_expenses/app.dart';
import 'package:monthly_expenses/features/settings/settings_parameters.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencySelector extends StatefulWidget {
  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  final _currencies = <String>[
    SettingsParameters.DefaultCurrencySymbol,
    "€",
    "£",
    "¥"
  ];
  late String _dropDownValue;

  @override
  void initState() {
    super.initState();

    _dropDownValue =
        App.preferences.getString(SettingsParameters.CurrencySymbol) ??
            SettingsParameters.DefaultCurrencySymbol;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("${AppLocalizations.of(context)?.selectCurrency}"),
        Spacer(),
        DropdownButton<String>(
          value: _dropDownValue,
          items: _currencies.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _dropDownValue = value!;
            });

            App.preferences
                .setString(SettingsParameters.CurrencySymbol, value!);
          },
        )
      ],
    );
  }
}
