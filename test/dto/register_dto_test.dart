import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/dto/register_dto.dart';

void main() {
  test(
      'RegisterDto.toMap should return Map base on given value '
      'on the constructor', () {
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
}
