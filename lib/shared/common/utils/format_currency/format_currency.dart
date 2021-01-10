import 'package:intl/intl.dart' as intl;

class FormatCurrency {
  static String toIDR(int number) => intl.NumberFormat.currency(
        locale: 'IN',
        decimalDigits: 0,
        symbol: 'IDR',
      ).format(number);
}
