import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/dto/auth_dto.dart';

void main() {
  group('AuthDto', () {
    group('LoginDto', () {
      test('toMap', () {
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
    });

    group('RegisterDto', () {
      test('toMap', () {
        final expectedMap = {
          'email': 'john@email.com',
          'firstName': 'John',
          'lastName': 'Doe',
          'password': 'somepassword',
        };

        final dto = RegisterDto(
          email: expectedMap['email'].toUpperCase(),
          firstName: expectedMap['firstName'],
          lastName: expectedMap['lastName'],
          password: expectedMap['password'],
        );

        expect(dto.toMap, expectedMap);
      });
    });
  });
}
