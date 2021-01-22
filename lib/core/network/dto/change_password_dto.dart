import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'dto.dart';

class ChangePasswordDto extends Equatable implements BaseDto {
  const ChangePasswordDto({
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
