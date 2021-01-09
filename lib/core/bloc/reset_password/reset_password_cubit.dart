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
    emit(state.copyWith(status: FormStatus.loading()));
    final result = await _authService.resetPassword(dto);
    result.fold(
      (l) {
        emit(state.copyWith(status: FormStatus.error(error: l)));
      },
      (r) {
        emit(state.copyWith(status: FormStatus.success()));
      },
    );
  }

  void changeShowAllForm(bool value) {
    if (state.showAllForm == value) return;
    emit(state.copyWith(showAllForm: value));
  }

  void clear() {
    emit(ResetPasswordState.initial());
  }
}
