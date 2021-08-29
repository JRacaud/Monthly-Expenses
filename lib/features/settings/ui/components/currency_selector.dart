import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:monthly_expenses/features/settings/settings_parameters.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencySelector extends StatefulWidget {
  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  final _currencies = <String>["€", "\$", "£", "¥"];
  late String _dropDownValue;

  @override
  void initState() async {
    super.initState();

    var prefs = await SharedPreferences.getInstance();
    _dropDownValue =
        prefs.getString(SettingsParameters.CurrencySymbol) ?? _currencies[0];
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
          onChanged: (value) async {
            setState(() {
              _dropDownValue = value!;
            });

            var prefs = await SharedPreferences.getInstance();
            prefs.setString(SettingsParameters.CurrencySymbol, value!);
          },
        )
      ],
    );
  }
}
