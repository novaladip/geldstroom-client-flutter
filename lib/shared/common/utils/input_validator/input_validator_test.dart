import 'package:flutter_test/flutter_test.dart';

import 'input_validator.dart';

void main() {
  group('InputValidator', () {
    test('email', () {
      final invalidEmail = 'invalid email';
      expect(
        InputValidator.email(invalidEmail, 'Email'),
        'Invalid email address',
      );

      final emptyEmail = '';
      expect(
        InputValidator.email(emptyEmail, 'Email'),
        'Email is cannot be empty',
      );

      final validEmail = 'john@email.com';
      expect(InputValidator.email(validEmail, 'Email'), null);
    });
    test('required', () {
      final invalidValue = '';
      expect(
        InputValidator.required(invalidValue, 'Field'),
        'Field is cannot be empty',
      );

      final validValue = 'some string';
      expect(InputValidator.required(validValue, 'Field'), null);
    });
    test('isEqual', () {
      final value1 = 'some string';
      final value2 = 'some string1';
      expect(InputValidator.isEqual(value1, value2, 'Field'), 'Invalid Field');
      expect(InputValidator.isEqual(value1, value1, 'Field'), null);
    });
    test('amount', () {
      final invalidAmount = '321dsa';
      expect(InputValidator.amount(invalidAmount),
          'Amount must be greater than 0');

      final validAmount = '100.000';
      expect(InputValidator.amount(validAmount), null);
    });
  });
}
