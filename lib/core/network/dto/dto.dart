export 'get_balance_dto.dart';
export 'login_dto.dart';
export 'register_dto.dart';
export 'reset_password_dto.dart';

abstract class BaseDto {
  Map<String, dynamic> get toMap;
}
