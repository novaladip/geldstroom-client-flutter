export 'login_dto.dart';
export 'register_dto.dart';

abstract class BaseDto {
  Map<String, dynamic> get toMap;
}
