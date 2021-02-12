part of 'form_none_cubit.dart';

@freezed
abstract class FormNoneState with _$FormNoneState {
  const factory FormNoneState({
    @required FormStatus status,
  }) = _FormState;

  factory FormNoneState.initial() => FormNoneState(status: FormStatus.idle());
}
