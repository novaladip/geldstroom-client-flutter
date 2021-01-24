import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../network/network.dart';

part 'password_reset_cubit.freezed.dart';
part 'password_reset_state.dart';

@lazySingleton
class PasswordResetCubit extends Cubit<PasswordResetState> {
  PasswordResetCubit(this._authService) : super(PasswordResetState.initial());

  final IAuthService _authService;

  Future<void> submit(PasswordResetDto dto) async {
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
    emit(PasswordResetState.initial());
  }
}
