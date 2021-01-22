import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/dto/change_password_dto.dart';

void main() {
  group('ChangePasswordDto', () {
    final password1 = ChangePasswordDto(
      oldPassword: '123123',
      password: '321321',
      passwordConfirmation: '321321',
    );
    final password2 = ChangePasswordDto(
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
}
