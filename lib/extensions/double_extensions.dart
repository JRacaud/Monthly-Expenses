import 'package:intl/intl.dart';

extension DoubleExtensions on double {
  String toCurrency() {
    NumberFormat formatter = NumberFormat.currency();

    return formatter.format(this);
  }
}
