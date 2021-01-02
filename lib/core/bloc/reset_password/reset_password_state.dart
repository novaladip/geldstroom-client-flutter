part of 'reset_password_cubit.dart';

@freezed
abstract class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState({
    @required FormStatus status,
  }) = _ResetPasswordState;
  factory ResetPasswordState.initial() =>
      ResetPasswordState(status: FormStatus.idle());
}
