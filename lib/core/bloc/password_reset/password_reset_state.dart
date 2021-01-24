part of 'password_reset_cubit.dart';

@freezed
abstract class PasswordResetState with _$PasswordResetState {
  const factory PasswordResetState({
    @required FormStatus status,
    @Default(false) bool showAllForm,
  }) = _ResetPasswordState;
  factory PasswordResetState.initial() =>
      PasswordResetState(status: FormStatus.idle());
}
