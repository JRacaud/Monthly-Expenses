import 'package:intl/intl.dart';

extension DoubleExtensions on double {
  String toCurrency() {
    NumberFormat formatter = NumberFormat.compactSimpleCurrency();

    return formatter.format(this);
  }
}
