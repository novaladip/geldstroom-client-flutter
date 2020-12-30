part of 'register_cubit.dart';

@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState({
    @required FormStatus status,
  }) = _RegisterState;

  factory RegisterState.initial() => RegisterState(
        status: FormStatus.idle(),
      );
}
