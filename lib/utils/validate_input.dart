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
