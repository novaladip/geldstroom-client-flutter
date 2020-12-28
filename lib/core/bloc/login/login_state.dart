part of 'login_cubit.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({@required FormStatus status}) = _LoginState;
  factory LoginState.initial() => LoginState(status: FormStatus.idle());
}
