import 'package:intl/intl.dart';
import 'package:monthly_expenses/features/settings/settings_parameters.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension DoubleExtensions on double {
  String toCurrency(String symbol) {
    var formatter = NumberFormat.currency(symbol: symbol);

    return formatter.format(this);
  }
}
