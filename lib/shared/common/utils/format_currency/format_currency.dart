import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;

class FormatCurrency {
  static String toIDR(int number) => intl.NumberFormat.currency(
        locale: 'IN',
        decimalDigits: 0,
        symbol: 'IDR',
      ).format(number);
}

class AmountFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    if (newText.isNotEmpty) {
      newText = _formatCurrency(newValue.text);
    }
    var selectionIndex = newText.length;

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  String _formatCurrency(String value) {
    final num = int.parse(value);
    return intl.NumberFormat.currency(
      locale: 'IN',
      decimalDigits: 0,
      symbol: '',
    ).format(num);
  }
}
