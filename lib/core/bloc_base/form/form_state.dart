part of 'form_cubit.dart';

@freezed
abstract class FormState with _$FormState {
  const factory FormState({@required FormStatus status}) = _FormState;

  factory FormState.initial() => FormState(status: FormStatus.idle());
}
