import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../shared/common/utils/utils.dart';
import '../bloc.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._jwtOps, this._overviewBalanceCubit)
      : super(AuthState.initial());

  final JwtOps _jwtOps;
  final OverviewBalanceCubit _overviewBalanceCubit;

  void appStarted() async {
    final token = await _jwtOps.getToken();
    if (token == null) {
      emit(AuthState.unauthenticated());
      return;
    }

    if (JwtDecoder.isExpired(token)) {
      emit(AuthState.unauthenticated());
      return;
    }

    loggedIn(token);
  }

  void loggedIn(String token) {
    _jwtOps.setDefaultAuthHeader(token);
    emit(AuthState.authenticated());
  }

  Future<void> loggedOut() async {
    _jwtOps.setDefaultAuthHeader('');
    await _jwtOps.removeToken();
    emit(AuthState.unauthenticated());
    _overviewBalanceCubit.clear();
  }
}
