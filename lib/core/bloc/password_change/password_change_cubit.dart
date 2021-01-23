import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../network/dto/dto.dart';
import '../../network/model/model.dart';
import '../../network/service/service.dart';

part 'password_change_cubit.freezed.dart';
part 'password_change_state.dart';

@lazySingleton
class PasswordChangeCubit extends Cubit<PasswordChangeState> {
  PasswordChangeCubit(this._service)
      : super(PasswordChangeState(FormStatus.idle()));

  final IUserService _service;

  Future<void> submit(ChangePasswordDto dto) async {
    emit(PasswordChangeState(FormStatus.loading()));
    final result = await _service.changePassword(dto);
    result.fold(
      (l) {
        emit(PasswordChangeState(FormStatus.error(error: l)));
      },
      (r) {
        emit(PasswordChangeState(FormStatus.success()));
        emit(PasswordChangeState(FormStatus.idle()));
      },
    );
  }

  void clear() {
    emit(PasswordChangeState(FormStatus.idle()));
  }
}
