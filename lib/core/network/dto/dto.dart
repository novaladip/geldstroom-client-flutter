export 'auth_dto.dart';
export 'balance_dto.dart';
export 'password_dto.dart';
export 'transaction_dto.dart';

abstract class BaseDto {
  Map<String, dynamic> get toMap;
}
