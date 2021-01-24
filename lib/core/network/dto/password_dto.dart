import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'dto.dart';

class PasswordResetDto implements BaseDto {
  final String password;
  final String email;
  final String otp;

  const PasswordResetDto({
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

class PasswordChangeDto extends Equatable implements BaseDto {
  const PasswordChangeDto({
    @required this.oldPassword,
    @required this.password,
    @required this.passwordConfirmation,
  });

  final String oldPassword;
  final String password;
  final String passwordConfirmation;

  @override
  Map<String, dynamic> get toMap => {
        'oldPassword': oldPassword,
        'password': password,
        'passwordConfirmation': passwordConfirmation,
      };

  @override
  List<Object> get props => [oldPassword, password, passwordConfirmation];
}
