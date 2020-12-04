import 'package:meta/meta.dart';

import 'dto.dart';

class RegisterDto implements BaseDto {
  const RegisterDto({
    @required this.email,
    @required this.firstName,
    @required this.lastName,
    @required this.password,
  });

  final String email;
  final String firstName;
  final String lastName;
  final String password;

  @override
  Map<String, dynamic> get toMap => {
        'email': email.toLowerCase(),
        'firstName': firstName,
        'lastName': lastName,
        'password': password,
      };
}
