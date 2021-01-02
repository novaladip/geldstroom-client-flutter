import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../network/network.dart';

part 'request_otp_cubit.freezed.dart';
part 'request_otp_state.dart';

@lazySingleton
class RequestOtpCubit extends Cubit<RequestOtpState> {
  RequestOtpCubit(this._authService) : super(RequestOtpState.initial());

  final IAuthService _authService;

  Future<void> submit(String email) async {
    emit(RequestOtpState(status: FormStatus.loading()));
    final result = await _authService.requestOtp(email);
    result.fold(
      (l) {
        emit(RequestOtpState(status: FormStatus.error(error: l)));
      },
      (r) {
        emit(RequestOtpState(status: FormStatus.success()));
      },
    );
  }

  void clear() {
    emit(RequestOtpState.initial());
  }
}
