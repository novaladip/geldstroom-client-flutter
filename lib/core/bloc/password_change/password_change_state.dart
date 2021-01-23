part of 'password_change_cubit.dart';

@freezed
abstract class PasswordChangeState with _$PasswordChangeState {
  const factory PasswordChangeState(FormStatus status) = _PasswordChangeState;
}
