import 'package:meta/meta.dart';

import 'dto.dart';

class ResetPasswordDto implements BaseDto {
  final String password;
  final String email;
  final String otp;

  const ResetPasswordDto({
    @required this.password,
    @required this.email,
    @required this.otp,
  });

  @override
  Map<String, dynamic> get toMap => {
        'password': password,
        'email': email.toLowerCase(),
        'OTP': otp,
      };
}
