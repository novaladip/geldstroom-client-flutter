import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../network/dto/dto.dart';
import '../../network/model/model.dart';
import '../../network/service/service.dart';

part 'register_cubit.freezed.dart';
part 'register_state.dart';

@lazySingleton
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(
    this._authService,
  ) : super(RegisterState.initial());

  final IAuthService _authService;

  Future<void> submit(RegisterDto dto) async {
    emit(state.copyWith(status: FormStatus.loading()));
    final result = await _authService.register(dto);
    result.fold(
      (l) => emit(RegisterState(status: FormStatus.error(error: l))),
      (r) => emit(RegisterState(status: FormStatus.success())),
    );
  }

  void clear() {
    emit(RegisterState.initial());
  }
}
