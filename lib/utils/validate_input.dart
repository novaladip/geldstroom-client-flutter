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

  return null;
}
