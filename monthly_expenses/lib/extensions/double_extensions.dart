import 'package:intl/intl.dart';

extension DoubleExtensions on double {
  String toCurrency(String symbol) {
    var formatter = NumberFormat.currency(symbol: symbol);

    return formatter.format(this);
  }
}