class InputValidator {
  static String email(String value, String fieldName) {
    final isValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value);

    if (value.isEmpty) {
      return '$fieldName is cannot be empty';
    }

    if (!isValid) {
      return 'Invalid email address';
    }

    return null;
  }

  static String required(String value, String fieldName) {
    if (value.isEmpty) {
      return '$fieldName is cannot be empty';
    }

    return null;
  }

  static String isEqual(String value, String valueToCompare, String fieldName) {
    if (value != valueToCompare) {
      return 'Invalid $fieldName';
    }

    return null;
  }

  static String amount(String value) {
    if (value.isEmpty) {
      return 'Amount is cannot be empty';
    }

    final num = int.tryParse(value.replaceAll('.', ''));
    if (num == null || num <= 0) {
      return 'Amount must be greater than 0';
    }
    return null;
  }
}
