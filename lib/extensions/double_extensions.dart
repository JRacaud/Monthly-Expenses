import 'package:intl/intl.dart';

extension DoubleExtensions on double {
  String toCurrency({String local = "EUR", String symbol = "€"}) {
    NumberFormat formatter =
        NumberFormat.currency(locale: local, symbol: symbol);

    return formatter.format(this);
  }
}
