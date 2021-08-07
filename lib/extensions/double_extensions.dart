import 'package:intl/intl.dart';

extension DoubleExtensions on double {
  String toCurrency() {
    NumberFormat formatter = NumberFormat.simpleCurrency();

    return formatter.format(this);
  }
}
