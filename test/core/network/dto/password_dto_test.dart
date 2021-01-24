import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/dto/dto.dart';

void main() {
  group('PasswordDto', () {
    group('PasswordChangeDto', () {
      final password1 = PasswordChangeDto(
        oldPassword: '123123',
        password: '321321',
        passwordConfirmation: '321321',
      );
      final password2 = PasswordChangeDto(
        oldPassword: '321321',
        password: '123123',
        passwordConfirmation: '123123',
      );

      test('support comparations value', () {
        expect(password1 != password2, true);
      });

      test('toMap', () {
        expect(password1.toMap, {
          'oldPassword': password1.oldPassword,
          'password': password1.password,
          'passwordConfirmation': password1.passwordConfirmation,
        });
      });
    });

    group('PasswordResetDto', () {
      test('toMap', () {
        final expectedMap = {
          'password': 'johnpassword',
          'email': 'john@email.com',
          'OTP': '123456',
        };

        final dto = PasswordResetDto(
          email: expectedMap['email'].toUpperCase(),
          otp: expectedMap['OTP'],
          password: expectedMap['password'],
        );

        expect(dto.toMap, expectedMap);
      });
    });
  });
}
