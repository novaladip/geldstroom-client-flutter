export 'change_password_dto.dart';
export 'get_balance_dto.dart';
export 'get_transaction_dto.dart';
export 'login_dto.dart';
export 'register_dto.dart';
export 'reset_password_dto.dart';
export 'transaction_create_dto.dart';
export 'transaction_edit_dto.dart';

abstract class BaseDto {
  Map<String, dynamic> get toMap;
}
