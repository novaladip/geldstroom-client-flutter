part of 'request_otp_cubit.dart';

@freezed
abstract class RequestOtpState with _$RequestOtpState {
  const factory RequestOtpState({
    FormStatus status,
  }) = _RequestOtpState;

  factory RequestOtpState.initial() => RequestOtpState(
        status: FormStatus.idle(),
      );
}
