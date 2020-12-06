import 'package:meta/meta.dart';

import 'dto.dart';

class LoginDto implements BaseDto {
  const LoginDto({
    @required this.email,
    @required this.password,
  });

  final String email;
  final String password;

  @override
  Map<String, dynamic> get toMap => {
        'email': email,
        'password': password,
      };
}
