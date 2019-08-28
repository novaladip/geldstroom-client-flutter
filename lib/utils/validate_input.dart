import 'package:validators/validators.dart';

String validateEmail(String value) {
  if (!isEmail(value)) {
    return 'Invalid email address';
  }
  return null;
}

String validatePassword(String value) {
  if (value.isEmpty) {
    return 'Password field cannot be empty';
  }

  if (value.length < 6) {
    return 'Password length must be longer than or equal to 6 characters';
  }

  return null;
}

String validatePasswordComfirmation(String value, String password) {
  if (value.isEmpty) {
    return 'Password Comfirmation cannot be empty';
  }

  if (value != password) {
    return 'Invalid password comfirmation';
  }

  return null;
}

String validateDescription(String value) {
  if (value.length > 10) {
    return 'Description length cannot be more than 10 character';
  }

  return null;
}

String validateAmount(String value) {
  final amount = int.tryParse(value);

  if (amount == null) {
    return 'Invalid amount';
  }

  if (amount <= 0) {
    return 'Amount must be positive number';
  }

  return null;
}
