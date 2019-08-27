import 'package:intl/intl.dart';

String formatCurrency(int value) {
  return NumberFormat.currency(locale: 'IN', decimalDigits: 2, symbol: 'IDR')
      .format(value);
}
