import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../network/network.dart';

part 'reset_password_cubit.freezed.dart';
part 'reset_password_state.dart';

@lazySingleton
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this._authService) : super(ResetPasswordState.initial());

  final IAuthService _authService;

  Future<void> submit(ResetPasswordDto dto) async {
    emit(ResetPasswordState(status: FormStatus.loading()));
    final result = await _authService.resetPassword(dto);
    result.fold(
      (l) {
        emit(ResetPasswordState(status: FormStatus.error(error: l)));
      },
      (r) {
        emit(ResetPasswordState(status: FormStatus.success()));
      },
    );
  }

  void clear() {
    emit(ResetPasswordState.initial());
  }
}
