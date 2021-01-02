import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/dto/reset_password_dto.dart';

void main() {
  test(
      'ResetPasswordDto.toMap should return Map base on given value '
      'on the constructor', () {
    final expectedMap = {
      'password': 'johnpassword',
      'email': 'john@email.com',
      'OTP': '123456',
    };

    final dto = ResetPasswordDto(
      email: expectedMap['email'].toUpperCase(),
      otp: expectedMap['OTP'],
      password: expectedMap['password'],
    );

    expect(dto.toMap, expectedMap);
  });
}
