import 'package:flutter_test/flutter_test.dart';

import 'login_dto.dart';

void main() {
  test(
      'LoginDto.toMap should return Map base on value given on the constructor',
      () {
    final expectedEmail = 'john@email.com';
    final expectedPassword = 'somepassword';
    final dto = LoginDto(
      email: expectedEmail,
      password: expectedPassword,
    );
    expect(dto.toMap, {
      'email': expectedEmail,
      'password': expectedPassword,
    });
  });
}
