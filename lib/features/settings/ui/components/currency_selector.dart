import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:monthly_expenses/app.dart';
import 'package:monthly_expenses/features/settings/settings_parameters.dart';

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

  String? _dropDownValue;

  _CurrencySelectorState() {
    var prefs = App.preferences;

    prefs.then((p) => setState(() {
          _dropDownValue = p.getString(SettingsParameters.CurrencySymbol) ??
              SettingsParameters.DefaultCurrencySymbol;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("${AppLocalizations.of(context)?.selectCurrency}"),
        Spacer(),
        DropdownButton<String>(
          value: _dropDownValue ?? SettingsParameters.DefaultCurrencySymbol,
          items: _currencies.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) async {
            setState(() {
              _dropDownValue = value!;
            });

            var prefs = await App.preferences;
            prefs.setString(SettingsParameters.CurrencySymbol, value!);
          },
        )
      ],
    );
  }
}
