import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/common/utils/utils.dart';
import '../../network/dto/dto.dart';
import '../../network/model/model.dart';
import '../../network/service/service.dart';
import '../bloc.dart';

part 'login_cubit.freezed.dart';
part 'login_state.dart';

@lazySingleton
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authService, this._authCubit, this._jwtOps)
      : super(LoginState.initial());

  final IAuthService _authService;
  final AuthCubit _authCubit;
  final JwtOps _jwtOps;

  Future<void> submit(LoginDto dto) async {
    emit(LoginState(status: FormStatus.loading()));
    final result = await _authService.loginWithEmail(dto);
    result.fold(
      (l) => emit(
        LoginState(status: FormStatus.error(error: l)),
      ),
      (r) {
        _jwtOps.persistToken(r);
        _authCubit.loggedIn(r);
        emit(LoginState(status: FormStatus.success()));
      },
    );
  }
}
